#!/sbin/openrc-run
# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

depend() {
	need net
	use logger
	provide ircd
}

start() {
	ebegin "Starting ngIRCd"
	start-stop-daemon --start --quiet --exec /usr/sbin/ngircd
	eend $?
}

stop() {
	ebegin "Stopping ngIRCd"
	start-stop-daemon --stop --quiet --exec /usr/sbin/ngircd
	eend $?
}
