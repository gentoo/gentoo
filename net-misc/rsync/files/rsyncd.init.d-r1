#!/sbin/runscript
# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/rsync/files/rsyncd.init.d-r1,v 1.1 2012/03/22 22:01:21 idl0r Exp $

command="/usr/bin/rsync"
command_args="--daemon ${RSYNC_OPTS}"
pidfile="/var/run/${SVCNAME}.pid"

depend() {
	use net
}
