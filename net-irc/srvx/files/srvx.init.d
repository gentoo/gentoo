#!/sbin/runscript
# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

depend() {
	use dns net
}

start() {
	ebegin "Starting srvx"
	start-stop-daemon --start --chdir /var/lib/srvx --quiet \
		--exec /usr/bin/srvx --chuid ${SRVX_USER}:${SRVX_GROUP} &>/dev/null
	eend $?
}

stop() {
	ebegin "Shutting down srvx"
	start-stop-daemon --stop --quiet --pidfile /var/lib/srvx/srvx.pid
	eend $?
}
