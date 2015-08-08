#!/sbin/runscript
# Copyright 1999-2015 Gentoo Foundation, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Id$

command="/usr/sbin/iscsid"
command_args="${OPTS}"
start_stop_daemon_args="-w 100" # iscsid might fail e.g. when the iSCSI kernel modules aren't available
pidfile=${PIDFILE:-/var/run/${SVCNAME}.pid}

extra_started_commands="starttargets stoptargets"
extra_commands="restarttargets"

ISCSIADM=/usr/sbin/iscsiadm

depend() {
	after modules multipath
	use net
}

checkconfig() {
	if [ ! -e /etc/conf.d/${SVCNAME} ]; then
		eerror "Config file /etc/conf.d/${SVCNAME} does not exist!"
		return 1
	fi
	if [ ! -e "${CONFIG_FILE}" ]; then
		eerror "Config file ${CONFIG_FILE} does not exist!"
		return 1
	fi

	if [ -e ${INITIATORNAME_FILE} ]; then
		. ${INITIATORNAME_FILE}
	fi
	if [ ! -e ${INITIATORNAME_FILE} -o -z "${InitiatorName}" ]; then
		ewarn "${INITIATORNAME_FILE} should contain a string with your initiatior name."
		local IQN=$(/usr/sbin/iscsi-iname)
		ebegin "Creating InitiatorName ${IQN} in ${INITIATORNAME_FILE}"
		echo "InitiatorName=${IQN}" >> "${INITIATORNAME_FILE}"
		eend $?
	fi
}

starttargets() {
	ebegin "Setting up iSCSI targets"
	$ISCSIADM -m node --loginall=automatic
	local ret=$?
	eend $ret
	return $ret
}

stoptargets() {
	ebegin "Disconnecting iSCSI targets"
	sync
	$ISCSIADM -m node --logoutall=all
	local ret=$?

	if [ $ret -eq 21 ]; then
		# See man iscsiadm(8)
		einfo "No active sessions to disconnect"
		eend 0
		return 0
	fi

	eend $ret
	return $ret
}

restarttargets() {
        stoptargets
        starttargets
}

status() {
	ebegin "Showing current active iSCSI sessions"
	$ISCSIADM -m session
}


start_pre() {
	local ret=1

	ebegin "Checking Open-iSCSI configuration"
	checkconfig
	ret=$?
	if [ $ret -ne 0 ]; then
		eend 1
		return 1
	fi
	eend 0
}

start_post() {
	# Start automatic targets when iscsid is started
	if [ "${AUTOSTARTTARGETS}" = "yes" ]; then
		starttargets
		local ret=$?
		if [ "${AUTOSTART}" = "strict" -a $ret -ne 0 ]; then
			stop
			return $ret
		fi
	fi
	return 0
}

stop_pre() {
	stoptargets
}
