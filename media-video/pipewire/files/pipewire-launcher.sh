#!/bin/sh

# We need to kill any existing pipewire instance to restore sound
pkill -u "${USER}" -x pipewire 1>/dev/null 2>&1

exec /usr/bin/pipewire
