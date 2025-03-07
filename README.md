# Remote Chrome
[中文文档](README_CN.md)

A Docker container with Google Chrome browser accessible remotely via web browser using noVNC.

## Features

* Run Google Chrome in a Docker container
* Access via web browser using noVNC

## Usage

### Using Docker CLI

```
docker run -d \
  --name remote-chrome \
  -p 9870:9870 \
  -e VNC_PASSWORD=your_secure_password_here \
  ghcr.io/novaraye/remote-chrome:latest
```

### Environment Variables

* `VNC_PASSWORD`: Set a password for VNC access (if not set, no authentication is used)
* `VNC_RESOLUTION`: Screen resolution (default: 1280x720)
