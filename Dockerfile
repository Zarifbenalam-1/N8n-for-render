# Use the alpine-specific tag which includes the apk package manager
FROM n8nio/n8n:latest-alpine

# Switch to root to install system packages
USER root

# 1. Install Python, Perl (for ExifTool), and pre-compiled data science libraries
# We use APK for everything to avoid slow 'pip' compilation on Render's free tier
RUN apk add --no-cache --update \
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

# 2. (Optional) Small pure-python libraries can be added here
# RUN pip3 install --break-system-packages library-name

# Switch back to the 'node' user for security
USER node
