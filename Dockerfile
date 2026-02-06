# Use the official Ubuntu-based image from n8n
# "latest-ubuntu" is the standard tag for non-Alpine builds now
FROM n8nio/n8n:latest-ubuntu

USER root

# Install dependencies (apt-get works here because it is Ubuntu)
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

USER node
