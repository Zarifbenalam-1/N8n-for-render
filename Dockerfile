# Start from a standard Node.js image (Debian Bookworm)
FROM node:20-bookworm

# 1. Install System Dependencies (ROOT MODE)
# We stay as root to install apt packages and n8n globally
USER root
RUN apt-get update && apt-get install -y \
    perl \
    libimage-exiftool-perl \
    python3-full \
    python3-pip \
    python3-venv \
    graphicsmagick \
    git \
    wget \
    curl \
    chromium \
    chromium-driver \
    fonts-freefont-ttf \
    && rm -rf /var/lib/apt/lists/*

# 2. Configure Browser Variables
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# 3. Install n8n globally (Root is needed for global npm install)
RUN npm install -g n8n puppeteer

# 4. Create Directory & Switch to User (USER MODE STARTS HERE)
# We ensure the home directory exists and is owned by 'node'
RUN mkdir -p /home/node/.n8n && chown -R node:node /home/node
USER node

# 5. Create Virtual Environment & Install Libraries
# Since we are now 'USER node', this venv will be owned by 'node'.
# No permission errors. No root warnings.
RUN python3 -m venv /home/node/python_env

# Install libraries specifically into this virtual environment
RUN /home/node/python_env/bin/pip install \
    pandas \
    numpy \
    requests \
    beautifulsoup4 \
    selenium \
    webdriver-manager

# --- ENV VARS ---
ENV NODE_ENV=production
ENV N8N_PORT=5678
ENV N8N_BLOCK_EXTERNAL_STORAGE_ACCESS=false

# 6. Point n8n to the USER-OWNED Python environment
ENV N8N_PYTHON_INTERPRETER=/home/node/python_env/bin/python

# Expose the port
EXPOSE 5678

# Start n8n
CMD ["n8n", "start"]
