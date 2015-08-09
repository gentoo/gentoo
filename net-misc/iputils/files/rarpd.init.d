#!/sbin/runscript
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

pidfile="/var/run/rarpd.pid"
command="/usr/sbin/rarpd"
# The -d option keeps it from forking.  This way s-s-d can do the fork and
# set up the pidfile with the right value below.
command_args="-d ${RARPD_OPTS} ${RARPD_IFACE}"
start_stop_daemon_args="--background --make-pidfile"

start_pre() {
	if [ ! -f /etc/ethers ] ; then
		eerror "Please create /etc/ethers with the following content:"
		eerror "[MAC address] [name or IP]"
		return 1
	fi
	return 0
}
