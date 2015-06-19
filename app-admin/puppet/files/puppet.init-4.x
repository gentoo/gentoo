#!/sbin/runscript
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

PUPPET_PID_DIR="${PUPPET_PID_DIR:-/var/run/puppet}"

pidfile="${PUPPET_PID_DIR}/puppet.pid"
PUPPET_LOG_DIR="/var/log/puppet"

command="/usr/bin/puppet"
extra_started_commands="reload"

command_args="agent --pidfile ${pidfile} --confdir /etc/puppetlabs/puppet ${PUPPET_EXTRA_OPTS}"

depend() {
	need localmount
	use dns logger puppetmaster netmount nfsmount
}

start_pre() {
	checkpath --directory --owner puppet:puppet "${PUPPET_PID_DIR}"
	checkpath --directory --owner puppet:puppet --mode 750 ${PUPPET_LOG_DIR}
}

reload() {
    ebegin "Reloading $RC_SVCNAME"
    start-stop-daemon --signal SIGHUP --pidfile "${pidfile}"
    eend $?
}
