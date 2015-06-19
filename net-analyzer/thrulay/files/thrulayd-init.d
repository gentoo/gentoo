#!/sbin/runscript
# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/thrulay/files/thrulayd-init.d,v 1.1 2005/06/04 19:28:50 robbat2 Exp $

depend() {
	use net
}

start() {
	[ -n "${THRULAYD_WINDOW}" ] && THRULAYD_OPTS="${THRULAYD_OPTS} -w${THRULAYD_WINDOW}"
	[ -n "${THRULAYD_PORT}" ] && THRULAYD_OPTS="${THRULAYD_OPTS} -p${THRULAYD_PORT}"
	ebegin "Starting thrulayd"
	start-stop-daemon --start --quiet --exec /usr/sbin/thrulayd -- ${THRULAYD_OPTS}
	eend $?
}

stop() {
	ebegin "Stopping thrulayd"
	start-stop-daemon --stop --quiet --exec /usr/sbin/thrulayd
	eend $?
}
