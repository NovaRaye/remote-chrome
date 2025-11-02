#!/bin/bash

CHROME_USER_DATA_DIR="/data/chrome-user-data"

# Support for multiple profiles via CHROME_PROFILE environment variable
# If CHROME_PROFILE is not set, use "default" as the profile name
if [ -z "$CHROME_PROFILE" ]; then
    CHROME_PROFILE="default"
fi

CHROME_PROFILE_DIR="$CHROME_USER_DATA_DIR/profiles/$CHROME_PROFILE"
echo "Using Chrome profile: $CHROME_PROFILE"

mkdir -p "$CHROME_PROFILE_DIR"

echo "Cleaning Chrome lock files..."
rm -f "$CHROME_PROFILE_DIR/SingletonLock"
rm -f "$CHROME_PROFILE_DIR/SingletonSocket" 
rm -f "$CHROME_PROFILE_DIR/SingletonCookie"

CHROME_CMD="/usr/bin/google-chrome-stable --no-sandbox --test-type --disable-dev-shm-usage --start-maximized --no-first-run --remote-debugging-port=19222 --user-data-dir=$CHROME_PROFILE_DIR"

EXTENSIONS=""

if [ -d "/data/chrome-extensions" ] && [ "$(ls -A /data/chrome-extensions 2>/dev/null)" ]; then
    for ext_dir in /data/chrome-extensions/*; do
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
