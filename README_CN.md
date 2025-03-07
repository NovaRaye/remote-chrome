# 远程 Chrome 浏览器

一个通过 noVNC 在网页浏览器中远程访问 Google Chrome 的 Docker 容器。

## 功能

* 在 Docker 容器中运行 Google Chrome 浏览器
* 通过网页浏览器使用 noVNC 进行访问

## 使用方法

### 使用 Docker

```
docker run -d \
  --name remote-chrome \
  -p 9870:9870 \
  -e VNC_PASSWORD=your_secure_password_here \
  ghcr.io/novaraye/remote-chrome:latest
```

### 环境变量

* `VNC_PASSWORD`: 设置 VNC 访问密码（如果未设置，则不使用身份验证）
* `VNC_RESOLUTION`: 屏幕分辨率（默认: 1280x720）
