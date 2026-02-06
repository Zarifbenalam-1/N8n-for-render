# Use LinuxServer.io image which is Ubuntu-based and reliable
FROM linuxserver/n8n:latest

# Switch to root (LinuxServer images run as root by default, but let's be explicit)
USER root

# Update and install dependencies
# Note: LinuxServer images use 'apt-get'
RUN apt-get update && apt-get install -y \
    perl \
    libimage-exiftool-perl \
    python3 \
    python3-pip \
    python3-venv \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Python libraries
RUN pip3 install --break-system-packages requests beautifulsoup4 pandas numpy

# LinuxServer images handle user permissions automatically at runtime
# No need to switch USER node at the end
