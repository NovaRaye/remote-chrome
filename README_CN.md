# 远程 Chrome 浏览器

一个通过 noVNC 在网页浏览器中远程访问 Google Chrome 的 Docker 容器。

## 功能

* 在 Docker 容器中运行 Google Chrome 浏览器
* 通过网页浏览器使用 noVNC 进行访问
* 支持通过 9222 端口使用 Chrome DevTools Protocol (CDP)

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

运行 Docker 命令后，您可以通过浏览器访问 http://localhost:9870 访问远程 Chrome 浏览器。

### Chrome DevTools Protocol (CDP)

您可以通过 9222 端口连接到 Chrome DevTools Protocol，这允许进行浏览器自动化、调试和测试。

使用 Puppeteer 的示例：

```javascript
const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.connect({
    browserURL: 'http://localhost:9222',
  });
  // 正常使用 Puppeteer 操作浏览器
})();
```

### 环境变量

* `VNC_PASSWORD`: 设置 VNC 访问密码（如果未设置，则不使用身份验证）
* `VNC_RESOLUTION`: 屏幕分辨率（默认: 1280x720）
