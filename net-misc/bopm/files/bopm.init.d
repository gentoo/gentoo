#!/sbin/runscript
# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/bopm/files/bopm.init.d,v 1.3 2004/07/14 23:55:10 agriffis Exp $

opts="depend start stop"

depend() {
	need net
}

start() {
	ebegin "Starting Blitzed Open Proxy Monitor"
	start-stop-daemon --start --quiet --chuid ${BOPM_UID} --exec /usr/bin/bopm
	eend $?
}

stop() {
	ebegin "Stopping Blitzed Open Proxy Monitor"
	kill $(</var/run/bopm/bopm.pid)
	eend $?
	rm -f /var/run/bopm/bopm.pid
}
