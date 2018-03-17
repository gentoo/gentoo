#!/sbin/openrc-run
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

: ${TELEPORT_CONFDIR:=/etc/teleport}
: ${TELEPORT_PIDFILE:=/var/run/${SVCNAME}.pid}
: ${TELEPORT_BINARY:=/usr/bin/teleport}
: ${TELEPORT_LOGFILE:=/var/log/teleport.log}

depend() {
	need net
}

start() {
	ebegin "Starting Teleport SSH Service"
		start-stop-daemon --start --exec /usr/bin/teleport \
		--background --make-pidfile --pidfile "${TELEPORT_PIDFILE}" \
		--stderr "${TELEPORT_LOGFILE}" \
		-- start --config="${TELEPORT_CONFDIR}/teleport.yaml" \
		${TELEPORT_OPTS}
	eend $?
}

stop() {
	ebegin "Stopping Teleport SSH Service"
		start-stop-daemon --stop --exec /usr/bin/teleport \
		--pidfile "${TELEPORT_PIDFILE}"
	eend $?
}

reload() {
	checkconfig || return 1
	ebegin "Reloading ${SVCNAME}"
	start-stop-daemon --signal HUP \
	    --exec "${TELEPORT_BINARY}" --pidfile "${TELEPORT_PIDFILE}"
	eend $?
}
