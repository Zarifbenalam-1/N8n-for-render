FROM n8nio/n8n:latest

# Switch to root to install system packages
USER root

# 1. Install system dependencies and Python packages via APK
# "apt-get" is replaced with "apk". 
# We install py3-numpy and py3-pandas from the Alpine repo to avoid 
# compiling them from source (which would likely timeout on Render).
RUN apk add --update --no-cache \
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

# 2. (Optional) Install other pure-Python libraries via pip
# Only use this for small libraries not available in apk.
# We use --break-system-packages because Alpine manages python externally.
# RUN pip3 install --break-system-packages some-other-library

# Switch back to the 'node' user
USER node
