#!/sbin/runscript
# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

CONFFILE=/etc/opendkim/${SVCNAME}.conf

depend() {
	use dns logger net
	before mta
}

check_cfg() {

	PIDFILE=$(sed -ne 's/^[[:space:]]*PidFile[[:space:]]\+//p' "${CONFFILE}")
	local PIDDIR="${PIDFILE%/*}"
	if [ ! -d  "${PIDDIR}" ] ; then
		checkpath -q -d -o milter:milter -m 0755 "${PIDDIR}" || return 1
	fi
	if [ ! -f "${CONFFILE}" ] ; then
		eerror "Configuration file ${CONFFILE} is missing"
		return 1
	fi
	if [ -z "${PIDFILE}" ] ; then
		eerror "Configuration file needs PidFile setting - recommend adding 'PidFile /var/run/opendkim/${SVCNAME}.pid' to ${CONFFILE}"
		return 1
	fi

	if egrep -q '^[[:space:]]*Background[[:space:]]+no' "${CONFFILE}" ; then
		eerror "${SVCNAME} service cannot run with Background key set to yes!"
		return 1
	fi
}

start() {
	check_cfg || return 1
	
	# Remove stalled Unix socket if no other process is using it
	local UNIX_SOCKET=$(sed -ne 's/^[[:space:]]*Socket[[:space:]]\+\(unix\|local\)://p' "${CONFFILE}")

	if [ -S "${UNIX_SOCKET}" ] && ! fuser -s "${UNIX_SOCKET}"; then
		rm "${UNIX_SOCKET}"
	fi

	ebegin "Starting OpenDKIM"
	start-stop-daemon --start --pidfile "${PIDFILE}" \
		--exec /usr/sbin/opendkim -- -x "${CONFFILE}"
	eend $?
}

stop() {
	check_cfg || return 1
	ebegin "Stopping OpenDKIM"
	start-stop-daemon --stop --pidfile "${PIDFILE}"
	eend $?
}
