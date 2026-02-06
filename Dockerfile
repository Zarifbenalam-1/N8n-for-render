# Use the official standard n8n image (Alpine based)
# This tag DEFINITELY exists and Render can find it.
FROM n8nio/n8n:latest

# Switch to root to install packages
USER root

# Install Perl, ExifTool, and Python3 using Alpine's package manager (apk)
RUN apk add --no-cache \
    perl \
    exiftool \
    python3 \
    py3-pip \
    curl \
    wget

# Install Python libraries (using --break-system-packages for Alpine 3.19+)
RUN pip3 install --break-system-packages requests beautifulsoup4 pandas numpy

# Switch back to n8n user
USER node
