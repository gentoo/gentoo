#!/bin/sh
# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# This file is part of media-gfx/iscan
#
# This script changes the permissions and ownership of a USB device under
# /proc/bus/usb to grant access to this device to users in the scanner group.
#
# Ownership is set to root:scanner, permissions are set to 0660.
#
# Arguments :
# -----------
# ACTION=[add|remove]
# DEVNAME=/dev/bus/usb/BBB/DDD
# SUBSYSTEM=usb_device

OWNER="root"
GROUP="scanner"
PERMS="0660"

DEVICE="${DEVNAME/dev/proc}"

if [ "${ACTION}" = "add" -a "${SUBSYSTEM}" = "usb_device" -a -f "${DEVICE}" ]; then
    chmod ${PERMS} "${DEVICE}" && chown ${OWNER}:${GROUP} "${DEVICE}"
fi
