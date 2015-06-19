#!/sbin/runscript
# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/www-apache/anyterm/files/anyterm.init.d,v 1.1 2009/01/24 14:22:38 pva Exp $

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
