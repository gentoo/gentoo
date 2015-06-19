#!/sbin/runscript
# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/bluez/files/rfcomm-init.d,v 1.2 2013/12/23 23:05:20 eva Exp $

depend() {
	after coldplug
	need dbus localmount hostname
}

start() {
	if [ "${RFCOMM_ENABLE}" = "true" -a -x /usr/bin/rfcomm ]; then
		if [ -f "${RFCOMM_CONFIG}" ]; then
			ebegin "Starting rfcomm"
			/usr/bin/rfcomm -f "${RFCOMM_CONFIG}" bind all
			eend $?
		else
			ewarn "Not enabling rfcomm because RFCOMM_CONFIG does not exists"
		fi
	fi
}

stop() {
	ebegin "Shutting down rfcomm"
	/usr/bin/rfcomm release all
	eend $?
}
