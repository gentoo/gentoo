#!/bin/sh

restorecon_nvidia()
{
	if [ -x /sbin/restorecon ]; then
		ebegin "Restoring SELinux contexts for /dev/nvidia*"
		restorecon -F /dev/nvidia* >/dev/null 2>&1
		eend $?
	fi

	return 0
}

if [ $# -ne 1 ]; then
	echo "Invalid args" >&2
	exit 1
fi

case $1 in
	add|ADD)
		#hopefully this prevents infinite loops like bug #454740
		if lsmod | grep -iq nvidia; then
			/opt/bin/nvidia-smi > /dev/null
			restorecon_nvidia
		fi
		;;
	remove|REMOVE)
		rm -f /dev/nvidia*
		;;
esac

exit 0
