# Use the Debian-based image (standard, stable)
FROM n8nio/n8n:latest-debian

# Switch to root to install system packages
USER root

# Install dependencies: Perl, ExifTool, Python3, pip, and utilities
RUN apt-get update && apt-get install -y \
    perl \
    libimage-exiftool-perl \
    python3 \
    python3-pip \
    python3-venv \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

# (Optional) Install common Python libraries you might use in Code Nodes
RUN pip3 install --break-system-packages requests beautifulsoup4 pandas numpy

# Switch back to the 'node' user for security (n8n standard)
USER node
