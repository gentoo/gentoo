#!/bin/bash

if [ ! -s /etc/bind/rndc.key ]; then
    /usr/sbin/rndc-confgen -a > /dev/null 2>&1 || exit 1
    chmod 640 /etc/bind/rndc.key
    chown root.named /etc/bind/rndc.key
fi
