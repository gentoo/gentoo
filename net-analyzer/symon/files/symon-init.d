#!/sbin/runscript
# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the 2-clause BSD license
# $Id$

extra_started_commands="reload"

depend() {
	after bootmisc
	need localmount net
	use logger
}

reload() {
	ebegin "Reloading symon"
	start-stop-daemon \
		--pidfile /run/symon.pid \
		--exec /usr/sbin/symon \
		--signal HUP
	eend $?
}

start() {
	ebegin "Starting symon"
	start-stop-daemon --start --exec /usr/sbin/symon -- -u
	eend $?
}

stop() {
	ebegin "Stopping symon"
	start-stop-daemon --stop --pidfile /run/symon.pid
	eend $?
}
