# Remote Chrome

[中文文档](README_CN.md)

A Docker container with Google Chrome browser accessible remotely via web browser using noVNC.

## Features

- Run Google Chrome in a Docker container
- Access via web browser using noVNC
- Support for Chrome DevTools Protocol (CDP) on port 9222

## Usage

### Quick Start

```
docker run -d \
  --name remote-chrome \
  -p 9870:9870 \
  -p 9222:9222 \
  -e VNC_PASSWORD=your_secure_password_here \
  ghcr.io/novaraye/remote-chrome:latest
```

After running the Docker command, you can access the Remote Chrome browser via your web browser at http://localhost:9870

### Chrome DevTools Protocol (CDP)

You can connect to Chrome using the DevTools Protocol on port 9222. This allows for browser automation, debugging, and testing.

Example usage with Puppeteer:

```javascript
const puppeteer = require("puppeteer");

(async () => {
  const browser = await puppeteer.connect({
    browserURL: "http://localhost:9222",
  });
  // Use browser as normal with Puppeteer
})();
```

### Installing Extensions

You can install Chrome extensions by mapping a local directory with your extensions to the container:

```
docker run -d \
  --name remote-chrome \
  -p 9870:9870 \
  -p 9222:9222 \
  -e VNC_PASSWORD=your_secure_password_here \
  -v /path/to/your/extensions:/data/chrome-extensions \
  ghcr.io/novaraye/remote-chrome:latest
```

#### Extension Directory Structure

Each extension must be in its own subdirectory within `/data/chrome-extensions/`:

```
/data/chrome-extensions/
├── extension1/
│   ├── manifest.json
│   └── ... (extension files)
├── extension2/
│   ├── manifest.json
│   └── ... (extension files)
```

All valid extensions placed in this structure will be loaded automatically when the container starts.

### Environment Variables

- `VNC_PASSWORD`: Set a password for VNC access (if not set, no authentication is used)
- `VNC_RESOLUTION`: Screen resolution (default: 1920x1080)
- `HTTP_PROXY`: HTTP proxy server (e.g., http://proxy.example.com:8080)
