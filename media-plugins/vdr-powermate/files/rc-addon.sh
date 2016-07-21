# plugin-startup-skript for powermate-plugin
# $Id$

# try to autodetect device for powermate

detect_powermate() {
	POWERMATE_DEVICE=""

	local devfile
	local base
	local sysfile
	local linkdest

	for devfile in /dev/input/event*; do
		# check if devile is device
		[ -c "${devfile}" ] || continue

		# and for corresponding sysfs-entry
		base=${devfile/\/dev\/input\//}
		sysfile=/sys/class/input/${base}/device/driver
		[ -L "${sysfile}" ] || continue

		# if driver-link contains powermate
		linkdest=$(readlink ${sysfile})
		[ "${linkdest}" != "${linkdest#*powermate}" ] || continue

		# the we are done
		POWERMATE_DEVICE="${devfile}"
		break
	done
}

plugin_pre_vdr_start() {
	if [ "${POWERMATE_DEVICE:-auto}" = "auto" ]; then
		detect_powermate
	fi

	if [ -c "${POWERMATE_DEVICE}" ]; then
		chown vdr:vdr "${POWERMATE_DEVICE}"
		add_plugin_param "--device=${POWERMATE_DEVICE}"
	else
		ewarn "No powermate-device found."
	fi
}

