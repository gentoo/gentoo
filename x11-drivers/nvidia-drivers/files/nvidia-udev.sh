#!/bin/sh

if [ $# -ne 1 ]; then
	echo "Invalid args" >&2
	exit 1
fi

case $1 in
	add|ADD)
		/opt/bin/nvidia-smi > /dev/null
		;;
	remove|REMOVE)
		rm -f /dev/nvidia*
		;;
esac

exit 0
