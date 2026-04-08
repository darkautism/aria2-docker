# AriaNg Web UI

Apache-hosted AriaNg web interface for Aria2.

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `ARIA2_HOST` | Aria2 RPC host | localhost |
| `ARIA2_PORT` | Aria2 RPC port | 6800 |
| `ARIA2_SECRET` | Aria2 RPC secret | (none) |

## Usage

### Docker Run

```bash
docker run -d \
  --name ariang \
  -p 8080:8080 \
  -e ARIA2_HOST=aria2 \
  -e ARIA2_PORT=6800 \
  -e ARIA2_SECRET=your-secret-token \
  ghcr.io/darkautism/aria2-docker-ariang:latest
```

### Docker Compose

See `docker-compose.yml` in the root directory.

## Build

```bash
cd ariang
docker build -t ariang .
```

Access AriaNg at `http://localhost:8080`