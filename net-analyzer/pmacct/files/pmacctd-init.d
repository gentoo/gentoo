#!/sbin/runscript
# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/pmacct/files/pmacctd-init.d,v 1.8 2014/02/01 12:07:33 jer Exp $

PMACCTDDIR=${PMACCTDDIR:-/etc/pmacctd}
if [ ${SVCNAME} != "pmacctd" ]; then
	PMACCTDPID="/run/${SVCNAME}.pid"
else
	PMACCTDPID="/run/pmacctd.pid"
fi
PMACCTDCONF="${PMACCTDDIR}/${SVCNAME}.conf"

depend() {
	need net
}

checkconfig() {
	if [ ! -e ${PMACCTDCONF} ] ; then
		eerror "You need an ${PMACCTDCONF} file to run pmacctd"
		return 1
	fi
}

start() {
	checkconfig || return 1
	ebegin "Starting ${SVCNAME}"
	start-stop-daemon --start --pidfile "${PMACCTDPID}" --exec /usr/sbin/"${SVCNAME}" \
		-- -D -f "${PMACCTDCONF}" -F "${PMACCTDPID}" ${OPTS}
	eend $?
}

stop() {
	ebegin "Stopping ${SVCNAME}"
	start-stop-daemon --stop --pidfile "${PMACCTDPID}" --exec /usr/sbin/"${SVCNAME}"
	eend $?
}
