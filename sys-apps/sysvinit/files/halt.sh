#!/bin/sh

. /lib/gentoo/functions.sh

if [ "$1" = reboot ]; then
	einfo "Rebooting system"
	exec /sbin/reboot -dkn
elif [ "$INIT_HALT" = HALT ]; then
	einfo "Halting system"
	exec /sbin/halt -dhn
else
	einfo "Powering off system"
	exec /sbin/poweroff -dhn
fi
