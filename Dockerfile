# STAGE 1: Builder
# We use a standard Alpine image to fetch the static installer tools
FROM alpine:latest as builder
WORKDIR /tmp

# Download the static APK package manager
# This complex command automatically finds the correct version for your architecture
RUN apk add --no-cache wget tar && \
    ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then ARCH="x86_64"; else ARCH="aarch64"; fi && \
    wget -qO- "http://dl-cdn.alpinelinux.org/alpine/latest-stable/main/${ARCH}/" | \
    grep -o 'href="apk-tools-static-[^"]*\.apk"' | head -1 | cut -d'"' -f2 | \
    xargs -I {} wget -q "http://dl-cdn.alpinelinux.org/alpine/latest-stable/main/${ARCH}/{}" && \
    tar -xzf apk-tools-static-*.apk

# STAGE 2: Final n8n Image
FROM n8nio/n8n:latest

# Switch to root to perform installations
USER root

# 1. Copy the static installer from the builder stage
COPY --from=builder /tmp/sbin/apk.static /usr/local/bin/apk-static

# 2. Configure Alpine Repositories (Required because they are missing in distroless)
# We add both 'main' and 'community' repos to find packages like pandas
RUN echo "http://dl-cdn.alpinelinux.org/alpine/latest-stable/main" > /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories

# 3. Install the real APK tools and your Python dependencies
# We use the static installer to bootstrap the system
RUN /usr/local/bin/apk-static add --no-cache --allow-untrusted apk-tools && \
    apk add --no-cache --update \
    perl \
    exiftool \
    python3 \
    py3-pip \
    py3-pandas \
    py3-numpy \
    py3-requests \
    py3-beautifulsoup4 \
    wget \
    curl \
    ca-certificates

# Switch back to the 'node' user for security
USER node
