FROM python:3.11-slim

# System deps
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# App dir
WORKDIR /app

# Python deps
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# App code + start script
COPY app.py .
COPY start.sh .

# Expose app port (Render will still inject $PORT)
EXPOSE 10000

# Use shell form so ${PORT} expands
CMD ./start.sh

