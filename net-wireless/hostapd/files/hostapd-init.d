#!/sbin/runscript
# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

pidfile="/run/${SVCNAME}.pid"
command="/usr/sbin/hostapd"
command_args="-P ${pidfile} -B ${OPTIONS} ${CONFIGS}"

extra_started_commands="reload"

depend() {
	local myneeds=
	for iface in ${INTERFACES}; do
		myneeds="${myneeds} net.${iface}"
	done

	[ -n "${myneeds}" ] && need ${myneeds}
	use logger
}

start_pre() {
	local file

	for file in ${CONFIGS}; do
		if [ ! -r "${file}" ]; then
			eerror "hostapd configuration file (${CONFIG}) not found"
			return 1
		fi
	done
}

reload() {
	start_pre || return 1

	ebegin "Reloading ${SVCNAME} configuration"
	kill -HUP $(cat ${pidfile}) > /dev/null 2>&1
	eend $?
}
