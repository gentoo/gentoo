#!/sbin/runscript
# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/razercfg/files/razerd.init.d,v 1.1 2011/08/17 18:39:36 joker Exp $

depend() {
	use logger
}

PIDFILE=/var/run/razerd/razerd.pid

start() {
	ebegin "Starting razerd"
	start-stop-daemon --start \
		--pidfile ${PIDFILE} \
		--exec /usr/sbin/razerd \
		-- --background --pidfile ${PIDFILE}
	eend $?
}

stop() {
	ebegin "Stopping razerd"
	start-stop-daemon --stop --pidfile ${PIDFILE}
	eend $?
}

