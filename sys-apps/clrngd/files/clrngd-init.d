#!/sbin/runscript
# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/clrngd/files/clrngd-init.d,v 1.3 2004/07/15 00:38:27 agriffis Exp $

DAEMON=clrngd
OPTS=${DELAYTIME}

start() {
	ebegin "Starting ${DAEMON}"
	start-stop-daemon --start --quiet --exec /usr/sbin/${DAEMON} ${OPTS}
	eend $?
}

stop() {
	ebegin "Stopping ${DAEMON}"
	start-stop-daemon --stop --quiet --exec /usr/sbin/${DAEMON}
	eend $?
}
