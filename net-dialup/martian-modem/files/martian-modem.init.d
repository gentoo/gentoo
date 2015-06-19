#!/sbin/runscript
# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/martian-modem/files/martian-modem.init.d,v 1.1 2012/12/15 16:41:36 pacho Exp $

daemon=/usr/sbin/martian_modem
description="Initscript to run the userspace daemon for winmodems supported by martian-modem driver"

: ${device:=${DEVICE:-/dev/ttySM0}}
: ${logfile:=${LOGFILE:-/var/log/martian-modem.log}}
: ${user:=${USER:-nobody}}
: ${group:=${GROUP:-dialout}}
: ${debug_level:=${DEBUG_LEVEL:-1}}
: ${use_syslog:=${USE_SYSLOG:-YES}}
pidfile=/var/run/${SVCNAME}.pid

depend() {
	    need localmount
	    [ "${use_syslog}" = "YES" ] && use syslog
}

start() {
	    if [ -e /proc/modules ] ; then
		local modem=
		for modem in /dev/modem /dev/ttySM[0-9]* ; do
			[ -e "${modem}" ] && break
		done
	    fi
	    if [ ! -e "${modem}" ] ; then
		    modprobe martian-dev || eerror $? "Error loading martian-dev module"
	    fi

	    if ! yesno "${use_syslog}" ; then
		    martian_opts="${MARTIAN_OPTS} --log=${logfile}"
	    else
		    martian_opts="${MARTIAN_OPTS} --syslog"
	    fi
	    
	    ebegin "Starting ${SVCNAME}"
	    start-stop-daemon --start --exec ${daemon} --user ${user}:${group} \
		    --pidfile ${pidfile} --make-pidfile --background \
		    -- ${martian_opts} --debug=${debug_level} ${device}
	    eend $?
}

stop() {
	ebegin "Stopping ${SVCNAME}"
	start-stop-daemon --stop --pidfile ${pidfile}
	eend $?
}
