# fire-tv-auto-launcher

Automatically launches [Wolf Launcher](https://github.com/nicholasgasior/wolf-launcher) on your Fire TV Stick whenever the default Amazon launcher is detected. Runs as a lightweight Docker container with minimal resource usage.

## How It Works

The container runs an ADB script that polls your Fire TV Stick every 60 seconds. When it detects the Amazon launcher (`com.amazon.tv.launcher`) is active, it immediately launches Wolf Launcher (`com.wolf.firelauncher`).

## Quick Start

### Docker

```bash
docker run -d \
  --name fire-tv-auto-launcher \
  --restart unless-stopped \
  --network host \
  -e FIRE_IP=192.168.1.50 \
  ghcr.io/ksmarty/fire-tv-auto-launcher:latest
```

### Docker Compose

```yaml
services:
  fire-tv-auto-launcher:
    image: ghcr.io/ksmarty/fire-tv-auto-launcher:latest
    container_name: fire-tv-auto-launcher
    restart: unless-stopped
    environment:
      - FIRE_IP=192.168.1.50
    network_mode: host
```

```bash
docker compose up -d
```

## Configuration

| Variable | Required | Description |
|----------|----------|-------------|
| `FIRE_IP` | Yes | IP address of your Fire TV Stick on your local network |

To find your Fire TV Stick's IP: go to **Settings → My Fire TV → About → Network** on the device.

## Updating

Pull the latest image:

```bash
docker pull ghcr.io/ksmarty/fire-tv-auto-launcher:latest
docker compose up -d
```

## Credits

This project is based on [**wolf-launcher-pi-trigger.sh**](https://gist.github.com/k-spr/a92fcf5c9bf6a56388b7fb61cc7ddda2) by [k-spr](https://github.com/k-spr). The original script detects Amazon's launcher via ADB and triggers Wolf Launcher — this repository packages that logic into a Docker container.

## License

MIT
