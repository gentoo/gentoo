#!/sbin/runscript
# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License, v2 or later
# $Id$

depend() {
	need net
}

start() {
	ebegin "Starting ${SVCNAME}"
	start-stop-daemon --start --exec /usr/sbin/anytermd -- \
		--user "${USER}" --port ${PORT} ${ANYTERM_OPTIONS}
	eend $?
}

stop() {
	ebegin "Stopping ${SVCNAME}"
	start-stop-daemon --stop --exec /usr/sbin/anytermd
	eend $?
}
