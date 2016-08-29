#!/sbin/openrc-run
# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

checkconfig() {
	if [ ! -f /etc/conf.d/lm_sensors ]; then
		eerror "/etc/conf.d/lm_sensors does not exist, try running sensors-detect"
		return 1
	fi

	if [ "${LOADMODULES}" = "yes" -a -f /proc/modules ]; then
		if [ -z "${MODULE_0}" ]; then
			eerror "MODULE_0 is not set in /etc/conf.d/lm_sensors, try running sensors-detect"
			return 1
		fi
	fi
}

start() {
	checkconfig || return 1

	if [ "${LOADMODULES}" = "yes" -a -f /proc/modules ]; then
		einfo "Loading lm_sensors modules..."

		mount | grep sysfs >/dev/null 2>&1
		if [ ${?} = 0 ]; then
			if ! ( [ -e /sys/i2c ] || [ -e /sys/bus/i2c ] ); then
				ebegin "  Loading i2c-core"
				modprobe i2c-core >/dev/null 2>&1
				if [ ${?} != 0 ]; then
					eerror "    Could not load i2c-core!"
					eend 1
				fi
				( [ -e /sys/i2c ] || [ -e /sys/bus/i2c ] ) || return 1
				eend 0
			fi
		elif ! [ -e /proc/sys/dev/sensors ]; then
			ebegin "  Loading i2c-proc"
			modprobe i2c-proc >/dev/null 2>&1
			if [ ${?} != 0 ]; then
				eerror "    Could not load i2c-proc!"
				eend 1
			fi
			[ -e /proc/sys/dev/sensors ] || return 1
			eend 0
		fi

		i=0
		while true; do
			module=`eval echo '$'MODULE_${i}`
			module_args=`eval echo '$'MODULE_${i}_ARGS`
			if [ -z "${module}" ]; then
				break
			fi
			ebegin "  Loading ${module}"
			modprobe ${module} ${module_args} >/dev/null 2>&1
			eend $?
			i=$(($i+1))
		done
	fi

	if [ "${INITSENSORS}" = "yes" ]; then
		if ! [ -f /etc/sensors3.conf ]; then
			eerror "/etc/sensors3.conf does not exist!"
			return 1
		fi

		ebegin "Initializing sensors"
		/usr/bin/sensors -s >/dev/null 2>&1
		eend ${?}
	fi
}

stop() {
	checkconfig || return 1

	if [ "${LOADMODULES}" = "yes" -a -f /proc/modules ]; then
		einfo "Unloading lm_sensors modules..."

		# find the highest possible MODULE_ number
		i=0
		while true; do
			module=`eval echo '$'MODULE_${i}`
			if [ -z "${module}" ] ; then
				break
			fi
			i=$(($i+1))
		done

		while [ ${i} -gt 0 ]; do
			i=$(($i-1))
			module=`eval echo '$'MODULE_${i}`
			ebegin "  Unloading ${module}"
			rmmod ${module} >/dev/null 2>&1
			eend $?
		done

		if [ -e /proc/sys/dev/sensors ] ; then
			ebegin "  Unloading i2c-proc"
			rmmod i2c-proc >/dev/null 2>&1
			eend $?
		fi
	fi
}
