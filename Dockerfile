FROM node:20-bookworm

USER root

# Install system dependencies
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

# Install n8n globally
RUN npm install -g n8n

# Create n8n directory
RUN mkdir -p /home/node/.n8n && chown -R node:node /home/node/.n8n

# Switch to 'node' user BEFORE creating the venv
# This ensures the venv is owned by 'node' and fully writable
USER node

# Create virtual environment as 'node' user
RUN python3 -m venv /home/node/python_env

# Install libraries into venv
RUN /home/node/python_env/bin/pip install --upgrade pip
RUN /home/node/python_env/bin/pip install pandas numpy requests beautifulsoup4

# Set Environment Variables
ENV NODE_ENV=production
ENV N8N_PORT=5678
ENV N8N_PYTHON_INTERPRETER=/home/node/python_env/bin/python

EXPOSE 5678

CMD ["n8n", "start"]
