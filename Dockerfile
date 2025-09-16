FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set workdir
WORKDIR /app

# Copy requirements and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code
COPY app.py .

# Expose port
EXPOSE 10000

# Run FastAPI app
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "10000"]
FROM python:3.11-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/*

# Install Go (latest stable)
RUN curl -OL https://go.dev/dl/go1.21.1.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go1.21.1.linux-amd64.tar.gz \
    && rm go1.21.1.linux-amd64.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"

# Install .NET SDK 7
RUN wget https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y dotnet-sdk-7.0 \
    && rm -rf /var/lib/apt/lists/*

# Set workdir
WORKDIR /app

# Copy requirements and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code
COPY app.py .

# Expose port
EXPOSE 10000

# Run FastAPI app
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "10000"]
FROM python:3.11-slim

# Install dependencies for multiple languages
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    golang \
    dotnet-sdk-7.0 \
    && rm -rf /var/lib/apt/lists/*

# Set workdir
WORKDIR /app

# Copy requirements and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code
COPY app.py .

# Expose port
EXPOSE 10000

# Run FastAPI app
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "10000"]

