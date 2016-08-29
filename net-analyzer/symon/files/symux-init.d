#!/sbin/openrc-run
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
	ebegin "Reloading symux"
	start-stop-daemon \
		--pidfile /run/symux.pid \
		--exec /usr/sbin/symux \
		--signal HUP
	eend $?
}

start() {
	ebegin "Starting symux"
	start-stop-daemon --start --exec /usr/sbin/symux
	eend $?
}

stop() {
	ebegin "Stopping symux"
	start-stop-daemon --stop --pidfile /run/symux.pid
	eend $?
}
