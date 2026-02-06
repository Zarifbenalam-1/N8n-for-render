# STAGE 1: Builder
FROM alpine:latest as builder
WORKDIR /tmp
# Download the static APK package manager
RUN apk add --no-cache wget tar && \
    ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then ARCH="x86_64"; else ARCH="aarch64"; fi && \
    wget -qO- "http://dl-cdn.alpinelinux.org/alpine/latest-stable/main/${ARCH}/" | \
    grep -o 'href="apk-tools-static-[^"]*\.apk"' | head -1 | cut -d'"' -f2 | \
    xargs -I {} wget -q "http://dl-cdn.alpinelinux.org/alpine/latest-stable/main/${ARCH}/{}" && \
    tar -xzf apk-tools-static-*.apk

# STAGE 2: Final n8n Image
FROM n8nio/n8n:latest

# Switch to root
USER root

# 1. Copy static installer
COPY --from=builder /tmp/sbin/apk.static /usr/local/bin/apk-static

# 2. Configure Repositories
RUN echo "http://dl-cdn.alpinelinux.org/alpine/latest-stable/main" > /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories

# 3. Bootstrap APK and Install Dependencies
# FIX IS HERE: We add '--initdb' to reset the package database and '--upgrade' to resolve the libapk conflict
RUN /usr/local/bin/apk-static add --no-cache --allow-untrusted --initdb --upgrade apk-tools && \
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

# Switch back to node user
USER node
