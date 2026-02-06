# Use the specific version that is guaranteed to be Debian-based
# We avoid 'latest' because it defaults to Alpine
FROM n8nio/n8n:1.77.2-debian

# Switch to root
USER root

# Update sources and install dependencies
# We add "|| true" to update to prevent failure on minor repo issues
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

# Install Python libraries
RUN pip3 install --break-system-packages requests beautifulsoup4 pandas numpy

# Switch back to node user
USER node
