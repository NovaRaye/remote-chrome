#!/bin/bash

CHROME_CMD="/usr/bin/google-chrome-stable --no-sandbox --test-type --disable-dev-shm-usage --start-maximized --no-first-run --remote-debugging-port=19222"

if [ ! -z "$CHROME_USER_DATA_DIR" ]; then
    echo "Using custom user data directory: $CHROME_USER_DATA_DIR"
    CHROME_CMD="$CHROME_CMD --user-data-dir=$CHROME_USER_DATA_DIR"
fi

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

# Handle proxy settings
if [ ! -z "$HTTP_PROXY" ] || [ ! -z "$http_proxy" ]; then
    PROXY="${HTTP_PROXY:-$http_proxy}"
    echo "Using HTTP proxy: $PROXY"
    CHROME_CMD="$CHROME_CMD --proxy-server=$PROXY"
elif [ ! -z "$HTTPS_PROXY" ] || [ ! -z "$https_proxy" ]; then
    PROXY="${HTTPS_PROXY:-$https_proxy}"
    echo "Using HTTPS proxy: $PROXY"
    CHROME_CMD="$CHROME_CMD --proxy-server=$PROXY"
elif [ ! -z "$ALL_PROXY" ] || [ ! -z "$all_proxy" ]; then
    PROXY="${ALL_PROXY:-$all_proxy}"
    echo "Using proxy: $PROXY"
    CHROME_CMD="$CHROME_CMD --proxy-server=$PROXY"
fi

# Check for no proxy settings
if [ ! -z "$NO_PROXY" ] || [ ! -z "$no_proxy" ]; then
    NO_PROXY_LIST="${NO_PROXY:-$no_proxy}"
    echo "No proxy for: $NO_PROXY_LIST"
    CHROME_CMD="$CHROME_CMD --proxy-bypass-list=$NO_PROXY_LIST"
fi

exec $CHROME_CMD
