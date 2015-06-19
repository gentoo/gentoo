#!/sbin/runscript
# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/firebird/files/firebird.init.d.2.5,v 1.3 2013/01/24 04:52:13 pinkbyte Exp $

depend() {
	need net
}

start_pre() {
	checkpath -d -o $FBUSER "$(dirname $PIDFILE)"
}

start(){
	ebegin "Starting Firebird server"
	start-stop-daemon --start --pidfile $PIDFILE --user $FBUSER --group $FBGROUP --exec $FBGUARD -- $FB_OPTS
	eend $?
}

stop(){
	ebegin "Stopping Firebird server"
	start-stop-daemon --stop --name fbguard
	eend $?
}

restart(){
	svc_stop
	sleep 1
	svc_start
}

