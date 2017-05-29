#!/sbin/openrc-run
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

PIDFILE=/run/teleport.pid

start() {
	ebegin "Starting Teleport SSH Service"
	start-stop-daemon --start --exec /usr/bin/teleport \
		--pidfile ${PIDFILE}
	eend $?
}

stop() {
	ebegin "Stopping Teleport SSH Service"
	start-stop-daemon --stop --exec /usr/bin/teleport \
		--pidfile ${PIDFILE}
	eend $?
}
