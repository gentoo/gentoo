#!/bin/sh
#
# irda-setup
#
# Initialize IrDA devices. Based on a Ubuntu init-script,
# but adapted to be called directly from udev.
#
# params: sir/fir <module> <options>

MODE="${1}"
shift

SYSFS="/sys"
RESOURCES="${SYSFS}${DEVPATH}/resources"

# Work out resource ranges, so we know which serial port to work with
PORTS=$(/bin/sed -n 's/io \(.*\)-.*/\1/p' "${RESOURCES}")
for PORT in ${PORTS}; do
	case "${PORT}" in
		0x3f8)
			PORT="/dev/ttyS0"
			break;;
		0x2f8)
			PORT="/dev/ttyS1"
			break;;
		0x3e8)
			PORT="/dev/ttyS2"
			break;;
		0x2e8)
			PORT="/dev/ttyS3"
			break;;
		default)
			PORT="UNKNOWN";;
	esac
done

# Handle FIR dongles
if [ "${MODE}" = "fir" ]; then
	# The BIOS doesn't always activate the device. Prod it
	echo disable > "${RESOURCES}"
	echo activate > "${RESOURCES}"

	UART="unknown";
	if [ "${PORT}" != "UNKNOWN" ]; then
		# We should attempt to disable the UART. However, we need to store
		# it - there's a chance that things could still go horribly wrong
		UART=$(/bin/setserial ${PORT} | /bin/sed 's/.*UART: \(.*\), Port.*/\1/')
		/bin/setserial ${PORT} uart none
	fi

	# Load FIR module
	/sbin/modprobe -sq "${@}" && exit 0  # OK

	# Try to recover
	[ "${UART}" != "undefined" ] && /bin/setserial ${PORT} uart ${UART}
fi

# We'll only have got here if we have SIR or the FIR module has failed
if [ "${PORT}" != "UNKNOWN" ]; then
	# The BIOS doesn't always activate the device. Prod it
	echo disable > "${RESOURCES}"
	echo activate > "${RESOURCES}"

	# The IRQ is not always set correctly, so try to deal with that
	/bin/setserial ${PORT} $(/bin/grep -h '^irq ' "${RESOURCES}")
fi

exit 0  # never fail
