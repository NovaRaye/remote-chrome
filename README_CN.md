# Remote Chrome

[English](README.md)

一个包含 Google Chrome 浏览器的 Docker 容器，可通过 noVNC 在网页浏览器中远程访问。

## 功能特点

- 在 Docker 容器中运行 Google Chrome
- 通过网页浏览器使用 noVNC 访问
- 支持 Chrome DevTools 协议(CDP)，端口 9222

## 使用方法

### 快速开始

```
docker run -d \
  --name remote-chrome \
  -p 9870:9870 \
  -p 9222:9222 \
  -e VNC_PASSWORD=your_secure_password_here \
  ghcr.io/novaraye/remote-chrome:latest
```

运行 Docker 命令后，您可以通过网页浏览器访问 Remote Chrome：http://localhost:9870

### Chrome DevTools 协议 (CDP)

您可以通过 9222 端口使用 DevTools 协议连接到 Chrome。这允许浏览器自动化、调试和测试。

使用 Puppeteer 的示例：

```javascript
const puppeteer = require("puppeteer");

(async () => {
  const browser = await puppeteer.connect({
    browserURL: "http://localhost:9222",
  });
  // 像正常使用Puppeteer一样使用browser
})();
```

### OpenClaw 集成

您可以通过在 OpenClaw 配置中设置浏览器 Profile，将 [OpenClaw](https://openclaw.ai) 连接到远程 Chrome 容器：

```json
{
  "browser": {
    "enabled": true,
    "defaultProfile": "remote-chrome",
    "profiles": {
      "remote-chrome": {
        "cdpUrl": "http://127.0.0.1:9222",
        "color": "ff5733"
      }
    }
  }
}
```

如有需要，将 `127.0.0.1` 替换为您的 Docker 宿主机或容器的实际 IP 地址。`color` 字段用于设置该 Profile 在 OpenClaw 界面中的指示颜色。

### 安装扩展

您可以通过将本地扩展目录映射到容器来安装 Chrome 扩展：

```
docker run -d \
  --name remote-chrome \
  -p 9870:9870 \
  -p 9222:9222 \
  -e VNC_PASSWORD=your_secure_password_here \
  -v /path/to/your/extensions:/data/chrome-extensions \
  ghcr.io/novaraye/remote-chrome:latest
```

#### 扩展目录结构

每个扩展必须位于`/data/chrome-extensions/`目录下的独立子目录中：

```
/data/chrome-extensions/
├── extension1/
│   ├── manifest.json
│   └── ... (扩展文件)
├── extension2/
│   ├── manifest.json
│   └── ... (扩展文件)
```

所有按照此结构放置的有效扩展将在容器启动时自动加载。

### 环境变量

- `VNC_PASSWORD`: 设置 VNC 访问密码(如果未设置，则不使用身份验证)
- `VNC_RESOLUTION`: 屏幕分辨率(默认: 1920x1080)
- `HTTP_PROXY`: HTTP 代理服务器（例如：http://proxy.example.com:8080）
