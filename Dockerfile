FROM debian:bullseye-slim

LABEL AboutImage="Chromium_NoVNC"

LABEL Maintainer="raye <s@raye.moe>"

ARG DEBIAN_FRONTEND=noninteractive

ENV VNC_TITLE="Chromium" \
    VNC_RESOLUTION="1280x720" \
    VNC_SHARED=0 \
    DISPLAY=:0 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ="Asia/Shanghai"

SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    apt-get install -y tzdata ca-certificates supervisor tigervnc-standalone-server websockify openbox libnss3 libgbm1 libasound2 fonts-droid-fallback wget gnupg socat && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    openssl req -new -newkey rsa:4096 -days 36500 -nodes -x509 -subj "/C=IN/ST=Maharastra/L=Private/O=Dis/CN=www.google.com" -keyout /etc/ssl/novnc.key  -out /etc/ssl/novnc.cert && \
    wget https://github.com/novnc/noVNC/archive/refs/tags/v1.4.0.tar.gz -O /tmp/novnc.tar.gz && \
    mkdir -p /opt/novnc && \
    tar -zxvf /tmp/novnc.tar.gz --strip-components=1 -C /opt/novnc && \
    mv /opt/novnc/vnc.html /opt/novnc/index.html && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

COPY rootfs/ /

ENTRYPOINT ["supervisord", "-l", "/var/log/supervisord.log", "-c"]

CMD ["/config/supervisord.conf"]