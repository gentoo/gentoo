#!/sbin/runscript
# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-misc/zoneminder/files/init.d,v 1.5 2014/04/25 14:43:40 dilfridge Exp $

depend() {
	need mysql
	need apache2
}

start_pre() {
	checkpath -d -m 0775 -o apache:apache /var/run/zm
	checkpath -d -m 0775 -o apache:apache /var/tmp/zm
}

start() {
	ebegin "Starting zoneminder"
	${CMD_START}
	eend $?
}

stop() {
	ebegin "Stopping zoneminder"
	${CMD_STOP}
	eend $?
}
