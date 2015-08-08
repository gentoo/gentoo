#!/sbin/runscript
# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
