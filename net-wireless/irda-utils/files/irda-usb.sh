#!/bin/sh
#
# irda-usb
#
# Hotplug IrDA-USB devices. Only USB devices are handled!
# To initialize normal SIR/FIR dongles, please use /etc/init.d/irda

SYSFS="/sys"

checkusb() {
	# quick check, but not always available
	[ "${PHYSDEVBUS}" = "usb" ] && return 0

	# alternative check via modalias
	/bin/grep -q '^usb:' "${SYSFS}${DEVPATH}/device/modalias" 2>/dev/null
}

checkconfig() {
	. /etc/conf.d/irda

	if [ "${DISCOVERY}" = "yes" ]; then
		DISCOVERY="-s"
	else
		DISCOVERY=""
	fi

	NET_IRDA_OPTS=""

	# Set maximum baud rate for IrDA
	if [ -n "${MAX_BAUD_RATE}" ]; then
		NET_IRDA_OPTS="${NET_IRDA_OPTS} net.irda.max_baud_rate=${MAX_BAUD_RATE}"
	fi

	# Disable discovery (enabling is done automatically by irattach)
	if [ -z "${DISCOVERY}" ]; then
		NET_IRDA_OPTS="${NET_IRDA_OPTS} net.irda.discovery=0"
	fi
}

case "${ACTION}" in
	add)
		# We handle USB only
		checkusb || exit 0

		# Load config
		checkconfig

		# Load IrDA modules
		/sbin/modprobe -sqa ircomm-tty ${LOAD_MODULES}

		# Set IrDA options
		[ -n "${NET_IRDA_OPTS}" ] && /sbin/sysctl -e -q -w ${NET_IRDA_OPTS}

		# Finally, attach IrDA device
		/usr/sbin/irattach ${INTERFACE} ${DISCOVERY}
		;;

	remove)
		# Unconditionally kill irattach instance
		/usr/bin/pkill -f "^/usr/sbin/irattach ${INTERFACE} ?"
		;;
esac
