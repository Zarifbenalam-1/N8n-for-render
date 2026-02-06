# Start from a standard Node.js image (Debian Bookworm)
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

# --- NEW LINES ADDED HERE ---
# 1. Create a dedicated virtual environment for n8n in the user's home directory
RUN python3 -m venv /home/node/python_env

# 2. Install your required Python libraries INTO that virtual environment
# We use the full path to 'pip' to ensure it installs in the correct place
RUN /home/node/python_env/bin/pip install pandas numpy requests beautifulsoup4
# ----------------------------

# Set environment variables
ENV NODE_ENV=production
ENV N8N_PORT=5678
ENV N8N_BLOCK_EXTERNAL_STORAGE_ACCESS=false

# --- CHANGED LINE ---
# Point n8n to the Python executable INSIDE the virtual environment we just made
ENV N8N_PYTHON_INTERPRETER=/home/node/python_env/bin/python
# --------------------

# Expose the port
EXPOSE 5678

# Start n8n
CMD ["n8n", "start"]
