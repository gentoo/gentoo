#!/bin/sh
if [ "${INIT_HALT}" = HALT ]; then
	exec /sbin/halt -dhn
else
	exec /sbin/poweroff -dhn
fi
