#!/sbin/openrc-run
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

depend() {
	need net
	use logger
}

start() {
	ebegin "Starting IGMPproxy"
	start-stop-daemon --start --background \
		--make-pidfile --pidfile /var/run/igmpproxy.pid \
		--exec /usr/sbin/igmpproxy -- \
		${IGMPPROXY_OPTS} "${IGMPPROXY_CONFIG:-/etc/igmpproxy.conf}"
	eend $?
}

stop() {
	ebegin "Stopping IGMPproxy"
	start-stop-daemon --stop --pidfile /var/run/igmpproxy.pid
	eend $?
}

