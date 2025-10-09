# Use a supported Python base image
FROM python:3.9-slim-bullseye

# Set working directory
WORKDIR /app

# Install system dependencies in one layer
RUN apt-get update && apt-get install -y --no-install-recommends \
        wget \
        gcc \
        libffi-dev \
        musl-dev \
        ffmpeg \
        aria2 \
        python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy project files
COPY . /app/

# Upgrade pip and install Python dependencies
RUN pip3 install --no-cache-dir --upgrade pip \
    && pip3 install --no-cache-dir --upgrade -r requirements.txt \
    && python3 -m pip install -U yt-dlp

# Default command: run Gunicorn in background and then main.py
CMD gunicorn app:app & python3 main.py
