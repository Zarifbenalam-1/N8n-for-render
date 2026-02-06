# Use specific n8n version based on newer Debian (Bookworm is current stable)
FROM n8nio/n8n:latest

# Switch to root to install system packages
USER root

# 1. Install system dependencies
# We use --allow-releaseinfo-change just in case, and fix the sources if needed
RUN apt-get update || true && \
    apt-get install -y --no-install-recommends \
    perl \
    libimage-exiftool-perl \
    python3 \
    python3-pip \
    python3-venv \
    wget \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# (Optional) Install Python libraries
RUN pip3 install --break-system-packages requests beautifulsoup4 pandas numpy

# Switch back to the 'node' user
USER node
