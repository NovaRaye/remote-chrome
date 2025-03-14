#!/bin/bash

CHROME_CMD="/usr/bin/google-chrome-stable --no-sandbox --test-type --disable-dev-shm-usage --start-maximized --no-first-run --remote-debugging-port=19222"

EXTENSIONS=""

if [ -d "/opt/chrome-extensions" ] && [ "$(ls -A /opt/chrome-extensions 2>/dev/null)" ]; then
    for ext_dir in /opt/chrome-extensions/*; do
        if [ -d "$ext_dir" ]; then
            if [ -z "$EXTENSIONS" ]; then
                EXTENSIONS="$ext_dir"
            else
                EXTENSIONS="$EXTENSIONS,$ext_dir"
            fi
        fi
    done
    
    if [ ! -z "$EXTENSIONS" ]; then
        CHROME_CMD="$CHROME_CMD --load-extension=$EXTENSIONS"
        echo "Loading extensions: $EXTENSIONS"
    fi
fi

exec $CHROME_CMD
