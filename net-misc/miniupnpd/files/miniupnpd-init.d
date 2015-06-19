#!/sbin/runscript
# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/miniupnpd/files/miniupnpd-init.d,v 1.3 2011/10/17 12:03:01 gurligebis Exp $

depend() {
	need net iptables
	use minissdpd
}

start() {
	ebegin "Starting miniupnpd"
	/etc/miniupnpd/iptables_init.sh
	start-stop-daemon --start --pidfile /var/run/miniupnpd.pid --exec /usr/sbin/miniupnpd -- ${ARGS}
	eend $?
}

stop() {
	ebegin "Stopping miniupnpd"
        start-stop-daemon --stop --pidfile /var/run/miniupnpd.pid
	eend $?
	/etc/miniupnpd/iptables_removeall.sh
}
