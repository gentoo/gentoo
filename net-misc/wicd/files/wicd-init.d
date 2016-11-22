#!/sbin/openrc-run
# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

opts="start stop restart"

WICD_DAEMON=/usr/sbin/wicd
WICD_PIDFILE=/var/run/wicd/wicd.pid

depend() {
	need dbus
}

start() {
	ebegin "Starting wicd daemon"
	"${WICD_DAEMON}" >/dev/null 2>&1
	eend $?
}

stop() {
	ebegin "Stopping wicd daemon"
	start-stop-daemon --stop --pidfile "${WICD_PIDFILE}"
	eend $?
}
