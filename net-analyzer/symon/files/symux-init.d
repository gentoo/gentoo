#!/sbin/runscript
# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the 2-clause BSD license
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/symon/files/symux-init.d,v 1.4 2014/06/24 01:31:06 jer Exp $

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
