# AriaNg Web UI

Apache-hosted AriaNg web interface for Aria2.

## Build

```bash
cd ariang
docker build -t ariang .
```

## Usage

```bash
docker run -d \
  --name ariang \
  -p 8080:8080 \
  ariang
```

Then access AriaNg at `http://localhost:8080`

Configure AriaNg to connect to Aria2:
- RPC Host: `aria2:6800` (if using docker-compose)
- RPC Secret: same as your Aria2 container