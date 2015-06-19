#!/sbin/runscript
# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/bluez/files/bluetooth-init.d-r2,v 1.1 2012/07/06 18:41:14 pacho Exp $

depend() {
	after coldplug
	need dbus localmount hostname
}

start() {
   	ebegin "Starting ${SVCNAME}"
	start-stop-daemon --start --exec /usr/sbin/bluetoothd
	eend $?
}

stop() {
	ebegin "Shutting down ${SVCNAME}"
	start-stop-daemon --stop --quiet --exec /usr/sbin/bluetoothd
	eend $?
}
