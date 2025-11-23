#!/sbin/openrc-run
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

extra_commands="configtest"
extra_started_commands="reload"

description="IRC server"
description_configtest="Run ngircd's internal config check."
description_reload="Reload the ngircd's configuration."

: ${NGIRCD_CONFIGFILE:=/etc/ngircd/${RC_SVCNAME}.conf}

command="/usr/sbin/ngircd"
command_args="${NGIRCD_OPTS} -f \"${NGIRCD_CONFIGFILE}\""
command_args_foreground="-n"
command_user="ngircd:ngircd"
pidfile="${NGIRCD_PIDFILE:-/var/run/ngircd/${RC_SVCNAME}.pid}"

depend() {
	need net
	use logger
	provide ircd
}

start_pre() {
	checkpath -f "${pidfile}" -o ${command_user} || return 1
	if [ "${RC_CMD}" != "restart" ]; then
		configtest || return 1
	fi
}

stop_pre() {
	if [ "${RC_CMD}" = "restart" ]; then
		configtest || return 1
	fi
}

reload() {
	configtest || return 1
	ebegin "Refreshing ${RC_SVCNAME}'s configuration"
	start-stop-daemon --signal SIGHUP --pidfile "${pidfile}"
	eend $? "Failed to reload ${RC_SVCNAME}"
}

configtest() {
	ebegin "Checking ${RC_SVCNAME}'s configuration"
	# "press enter to continue"
	echo | ${command} -f "${NGIRCD_CONFIGFILE}" -t >/dev/null

	eend $? "failed, please correct errors in the config file"
}
