#!/sbin/openrc-run
# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DAEMON=clrngd
OPTS=${DELAYTIME}

start() {
	ebegin "Starting ${DAEMON}"
	start-stop-daemon --start --quiet --exec /usr/sbin/${DAEMON} ${OPTS}
	eend $?
}

stop() {
	ebegin "Stopping ${DAEMON}"
	start-stop-daemon --stop --quiet --exec /usr/sbin/${DAEMON}
	eend $?
}
