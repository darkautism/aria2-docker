# Aria2 Docker Image

A minimal Aria2 container built from source.

## Supported Platforms

- `linux/amd64` (x86_64)
- `linux/arm64` (aarch64)

## Quick Start

```bash
# Pull latest (auto-detects architecture)
docker pull ghcr.io/<your-username>/aria2-docker:latest

# Pull specific architecture
docker pull ghcr.io/<your-username>/aria2-docker:amd64
docker pull ghcr.io/<your-username>/aria2-docker:arm64
```

## Usage

```bash
# Download a file
docker run --rm -v $(pwd)/downloads:/downloads ghcr.io/<your-username>/aria2-docker \
  aria2c -d /downloads -o file.iso "https://example.com/file.iso"

# Run as daemon with WebUI
docker run -d \
  --name aria2 \
  -v $(pwd)/config:/config \
  -v $(pwd)/downloads:/downloads \
  -p 6800:6800 \
  -p 6881:6881 \
  ghcr.io/<your-username>/aria2-docker \
  aria2c \
    --conf-path=/config/aria2.conf \
    --enable-rpc \
    --rpc-listen-all=true
```

## Build Manually

```bash
# Build for current platform
docker build -t aria2:latest .

# Build for specific architecture
docker build --platform linux/amd64 -t aria2:amd64 .
docker build --platform linux/arm64 -t aria2:arm64 .
```