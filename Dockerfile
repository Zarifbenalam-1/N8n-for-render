# Start from a standard Node.js image (Debian Bookworm)
# This guarantees we have 'apt-get' and a full OS
FROM node:20-bookworm

# Install system dependencies (Root user is default here)
RUN apt-get update && apt-get install -y \
    perl \
    libimage-exiftool-perl \
    python3 \
    python3-pip \
    python3-venv \
    graphicsmagick \
    git \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install n8n globally via npm
RUN npm install -g n8n

# Create a user 'node' (if not exists) and setup directories
RUN mkdir -p /home/node/.n8n && chown -R node:node /home/node/.n8n

# Switch to non-root user
USER node

# Set environment variables
ENV NODE_ENV=production
ENV N8N_PORT=5678
# Add these above your CMD ["n8n", "start"]
ENV N8N_BLOCK_EXTERNAL_STORAGE_ACCESS=false
ENV N8N_PYTHON_INTERPRETER=/usr/bin/python3
# Expose the port
EXPOSE 5678

# Start n8n
CMD ["n8n", "start"]
