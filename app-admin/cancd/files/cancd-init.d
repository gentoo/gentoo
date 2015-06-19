#!/sbin/runscript
# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/cancd/files/cancd-init.d,v 1.2 2011/12/31 15:42:32 idl0r Exp $

depend() {
	need net
}

start() {
	mkdir -p ${CRASH_DIR}
	chown ${CHUID} ${CRASH_DIR}
	chmod 700 ${CRASH_DIR}
	ebegin "Starting cancd"
	start-stop-daemon --start --quiet --user ${CHUID} --exec /usr/sbin/cancd  -- -p ${CANCD_PORT} -l "${CRASH_DIR}" -o "${CRASH_FORMAT}"
	eend ${?}
}

stop() {
	ebegin "Stopping cancd"
	start-stop-daemon --stop --quiet --exec /usr/sbin/cancd
	eend ${?}
}
