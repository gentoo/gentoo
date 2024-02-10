#!/bin/bash

. /etc/vgl.conf

vgl_start() {
    truncate --size=0 /var/lib/VirtualGL/vgl_xauth_key

    set_xauth
    # Check if XAUTHORITY was set successfully, if not wait up to
    # 60 seconds to allow X start.
    tries=120
    while [ ${tries} -gt 0 ]; do
        tries=$((tries - 1))
        if [ -z "${XAUTHORITY}" ]; then
            sleep 0.5
            set_xauth
            continue
        elif [ ! -e "${XAUTHORITY}" ]; then
            sleep 0.5
            # fall through, file not existing yet
        fi
        break
    done

    xauth -f /var/lib/VirtualGL/vgl_xauth_key add $DISPLAY . \
        $(xauth -f $XAUTHORITY list | awk '{print $3;exit}') && \
        chmod 644 /var/lib/VirtualGL/vgl_xauth_key
}

vgl_stop() {
    rm -f /var/lib/VirtualGL/vgl_xauth_key
}


if [ "${1}" = "start" ]; then
    vgl_start
elif [ "${1}" = "stop" ]; then
    vgl_stop
fi
