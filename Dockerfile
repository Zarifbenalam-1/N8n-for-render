# Start from a standard Node.js image (Debian Bookworm)
FROM node:20-bookworm

# 1. Install System Dependencies (Root User)
# We add 'python3-full' to ensure we have the complete Python standard library
RUN apt-get update && apt-get install -y \
    perl \
    libimage-exiftool-perl \
    python3-full \
    python3-pip \
    graphicsmagick \
    git \
    wget \
    curl \
    chromium \
    chromium-driver \
    fonts-freefont-ttf \
    && rm -rf /var/lib/apt/lists/*

# 2. Configure Browser Variables (For Puppeteer)
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# 3. Install Python Libraries GLOBALLY
# We use '--break-system-packages' because we are in a container and WANT to
# install these into the system python. This makes them available to all users.
RUN pip3 install --break-system-packages \
    pandas \
    numpy \
    requests \
    beautifulsoup4 \
    selenium \
    webdriver-manager

# 4. Install n8n and Puppeteer globally
RUN npm install -g n8n puppeteer

# 5. Create the 'node' user directory setup
RUN mkdir -p /home/node/.n8n && chown -R node:node /home/node/.n8n

# Switch to non-root user for security
USER node

# --- ENV VARS ---
ENV NODE_ENV=production
ENV N8N_PORT=5678
ENV N8N_BLOCK_EXTERNAL_STORAGE_ACCESS=false

# CRITICAL FIX: Point directly to the system python we just configured
ENV N8N_PYTHON_INTERPRETER=/usr/bin/python3

# Expose the port
EXPOSE 5678

# Start n8n
CMD ["n8n", "start"]
