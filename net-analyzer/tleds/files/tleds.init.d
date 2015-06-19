#!/sbin/runscript
# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/tleds/files/tleds.init.d,v 1.2 2004/07/14 23:13:14 agriffis Exp $


depend() {
	need net
}

start() {
	ebegin "Starting tleds"
	/usr/sbin/tleds -d ${DELAY} ${IFACE} ${EXTRA_OPTS} > /dev/null
	eend $?
}

stop() {
	ebegin "Stopping tleds"
	/usr/sbin/tleds -k > /dev/null
	eend $?
}

