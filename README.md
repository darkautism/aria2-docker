# Aria2 Docker Image

A minimal Aria2 container built from source with all features enabled (HTTP, FTP, SFTP, BitTorrent, Metalink, XML-RPC).

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

## Required Environment Variables

| Variable | Description |
|----------|-------------|
| `RPC_SECRET` | **Required** - RPC secret token for authentication |

## Mount Points

| Path | Description |
|------|-------------|
| `/config` | Configuration files and session storage (auto-populated with default config on first run) |
| `/downloads` | Download destination directory |

## Usage

### Run as RPC Service (with WebUI)

```bash
docker run -d \
  --name aria2 \
  -v $(pwd)/config:/config \
  -v $(pwd)/downloads:/downloads \
  -p 6800:6800 \
  -p 6881-6999:6881-6999 \
  -e RPC_SECRET=your-secret-token \
  ghcr.io/<your-username>/aria2-docker
```

The default configuration enables:
- RPC on port 6800
- BitTorrent on ports 6881-6999
- Downloads to `/downloads`
- Session saving to `/config/aria2.session`

### Override with CLI Arguments

```bash
docker run -d \
  --name aria2 \
  -v $(pwd)/config:/config \
  -v $(pwd)/downloads:/downloads \
  -p 6800:6800 \
  -p 6881-6999:6881-6999 \
  -e RPC_SECRET=your-secret-token \
  ghcr.io/<your-username>/aria2-docker \
  aria2c --conf-path=/config/aria2.conf --max-connection-per-server=8
```

### Basic One-time Download

```bash
docker run --rm -v $(pwd)/downloads:/downloads ghcr.io/<your-username>/aria2-docker \
  aria2c -d /downloads -o file.iso "https://example.com/file.iso"
```

## Common Parameters

### RPC Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `--enable-rpc` | Enable RPC interface | enabled |
| `--rpc-listen-all=true` | Listen on all interfaces | true |
| `--rpc-listen-port=6800` | RPC listen port | 6800 |
| `--rpc-secret=<secret>` | RPC secret token | required |
| `--rpc-allow-origin-all=true` | Allow all origins | true |

### Download Directory

| Parameter | Description | Default |
|-----------|-------------|---------|
| `--dir=/downloads` | Download directory | /downloads |

### Connection Settings

| Parameter | Description | Default |
|-----------|-------------|---------|
| `-x, --max-connection-per-server=16` | Max connections per server | 1 |
| `-s, --split=16` | Number of connections per file | 5 |
| `-k, --min-split-size=20M` | Minimum split size | 20M |
| `-j, --max-concurrent-downloads=5` | Max concurrent downloads | 5 |

### BitTorrent Settings

| Parameter | Description | Default |
|-----------|-------------|---------|
| `--listen-port=6881-6999` | TCP listen port for BT | 6881-6999 |
| `--enable-dht=true` | Enable IPv4 DHT | true |
| `--enable-dht6=true` | Enable IPv6 DHT | true |
| `--enable-peer-exchange=true` | Enable peer exchange | true |
| `--seed-ratio=1.0` | Seed ratio before stop | 1.0 |

### Session and Logging

| Parameter | Description | Default |
|-----------|-------------|---------|
| `--save-session=/config/aria2.session` | Save session file | none |
| `--save-session-interval=60` | Save session interval (sec) | 60 |
| `--log=/config/aria2.log` | Log file | none |

### Advanced

| Parameter | Description | Default |
|-----------|-------------|---------|
| `--disable-ipv6=false` | Enable IPv6 | false |
| `--check-integrity=true` | Verify checksums | false |
| `--continue=true` | Continue partial downloads | true |
| `--max-tries=5` | Retry attempts | 5 |
| `--retry-wait=0` | Wait between retries (sec) | 0 |

## Example: Custom Configuration

Create `config/aria2.conf`:

```conf
dir=/downloads
log=/config/aria2.log
save-session=/config/aria2.session
save-session-interval=60
log-level=notice

enable-rpc=true
rpc-listen-all=true
rpc-listen-port=6800

max-connection-per-server=16
split=16
min-split-size=20M

listen-port=6881-6999
enable-dht=true
enable-dht6=true
enable-peer-exchange=true
seed-ratio=1.0

continue=true
```

Run with custom config:

```bash
docker run -d \
  --name aria2 \
  -v $(pwd)/config:/config \
  -v $(pwd)/downloads:/downloads \
  -p 6800:6800 \
  -p 6881-6999:6881-6999 \
  -e RPC_SECRET=your-secret-token \
  ghcr.io/<your-username>/aria2-docker \
  aria2c --conf-path=/config/aria2.conf
```

## Build Manually

```bash
# Build for current platform
docker build -t aria2:latest .

# Build for specific architecture
docker build --platform linux/amd64 -t aria2:amd64 .
docker build --platform linux/arm64 -t aria2:arm64 .
```

## Tags

| Tag | Description |
|-----|-------------|
| `latest` | Latest stable release |
| `nightly` | Built from master branch (weekly) |
| `amd64` / `arm64` | Platform-specific tags |