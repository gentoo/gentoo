#!/sbin/runscript
# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

PIDFILE=/run/anope/services.pid

extra_started_commands="reload"

depend() {
	use ircd
}

start_pre() {
	checkpath -o ${ANOPE_USER} -d "$(dirname $PIDFILE)"
}

start() {
	ebegin "Starting Anope IRC Services"
	start-stop-daemon --start --exec /usr/bin/services \
		--user ${ANOPE_USER} --pidfile ${PIDFILE} \
		-- ${ANOPE_OPTS}
	eend $?
}

stop() {
	ebegin "Stopping Anope IRC Services"
	start-stop-daemon --stop --pidfile ${PIDFILE}
	eend $?
}

reload() {
	ebegin "Reloading Anope IRC Services"
        start-stop-daemon --signal USR2 --exec /usr/bin/services \
		--pidfile ${PIDFILE}
	eend $?
}

