#!/sbin/runscript
# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/gpm/files/gpm.rc6,v 1.12 2004/07/15 01:02:02 agriffis Exp $

#NB: Config is in /etc/conf.d/gpm

depend() {
	need localmount
	use hotplug logger
}

checkconfig() {
	if [ -z "$MOUSEDEV" ] || [ -z "$MOUSE" ] ; then
		eerror "You need to setup MOUSEDEV and MOUSE in /etc/conf.d/gpm first"
		return 1
	fi
}

start() {
	checkconfig || return 1

	local params=""
	[ -n "$RESPONSIVENESS" ] && params="$params -r $RESPONSIVENESS"
	[ -n "$REPEAT_TYPE" ]    && params="$params -R$REPEAT_TYPE"
	[ -n "$APPEND" ]         && params="$params $APPEND "
	
	ebegin "Starting gpm"
	start-stop-daemon --start --quiet --exec /usr/sbin/gpm \
		-- -m ${MOUSEDEV} -t ${MOUSE} ${params}
	eend ${?}
}

stop() {
	ebegin "Stopping gpm"
	start-stop-daemon --stop --quiet --pidfile /var/run/gpm.pid
	eend ${?}
}
