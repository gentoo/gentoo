#!/bin/sh

if [ $# -ne 1 ]; then
	echo "Invalid args" >&2
	exit 1
fi

case $1 in
	add|ADD)
		#hopefully this prevents infinite loops like bug #454740
		if lsmod | grep -iq nvidia; then
			/opt/bin/nvidia-smi > /dev/null
		fi
		;;
	remove|REMOVE)
		rm -f /dev/nvidia*
		;;
esac

exit 0
