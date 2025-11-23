#!/sbin/openrc-run
# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

description="A simple CalDAV (calendar) and CardDAV (contact) server"
PIDFILE=/run/radicale.pid

depend() {
	need localmount
}

start() {
	ebegin "Starting radicale"
		start-stop-daemon --start --quiet --background \
		--user radicale \
		--umask 0027 \
		--stderr-logger /usr/bin/logger \
		--pidfile ${PIDFILE} --make-pidfile \
		--exec /usr/bin/radicale
	eend $?
}

stop() {
	ebegin "Stopping radicale"
		start-stop-daemon --stop --quiet \
		--pidfile ${PIDFILE}
	eend $?
}
