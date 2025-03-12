#!/bin/bash

CHROME_CMD="/usr/bin/google-chrome-stable --no-sandbox --test-type --disable-dev-shm-usage --start-maximized --no-first-run --remote-debugging-port=19222"

if [ -d "/opt/chrome-extensions" ] && [ "$(ls -A /opt/chrome-extensions 2>/dev/null)" ]; then
    CHROME_CMD="$CHROME_CMD --load-extension=/opt/chrome-extensions"
fi

exec $CHROME_CMD
