#!/sbin/openrc-run
# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

description="An open-source turn-key solution for DNSSEC"

depend() {
	use logger
}

checkconfig() {
	if [ -z "${CHECKCONFIG_BIN}" ]; then
		# no config checker configured, skip config check
		return 0
	fi
	if [ -x "${CHECKCONFIG_BIN}" ]; then
		output=$(${CHECKCONFIG_BIN} 2>&1| grep -v -E "^/etc/opendnssec/(conf|kasp).xml validates")
		if [ -n "$output" ]; then
			echo $output
		fi

		errors=$(echo $output | grep ERROR | wc -l)
		if [ $errors -gt 0 ]; then
			ewarn "$errors error(s) found in OpenDNSSEC configuration."
		fi
		return $errors
	fi
	eerror "Unable to execute ${CHECKCONFIG_BIN:-config binary}"
	# can't validate config, just die
	return 1
}

start_enforcer() {
	if [ -n "${ENFORCER_BIN}" ] && [ -x "${ENFORCER_BIN}" ]; then
		ebegin "Starting OpenDNSSEC Enforcer"
		${CONTROL_BIN} enforcer start > /dev/null
		eend $?
	else
		if [ -n "${ENFORCER_BIN}" ]; then
			eerror "OpenDNSSEC Enforcer binary not executable"
			return 1
		fi
		einfo "OpenDNSSEC Enforcer not used."
	fi
}

stop_enforcer() {
	if [ -x "${ENFORCER_BIN}" ]; then
		ebegin "Stopping OpenDNSSEC Enforcer"
		${CONTROL_BIN} enforcer stop > /dev/null
		eend $?
	fi
}

start_signer() {
	if [ -n "${SIGNER_BIN}" ] && [ -x "${SIGNER_BIN}" ]; then
		ebegin "Starting OpenDNSSEC Signer"
		${CONTROL_BIN} signer start > /dev/null 2>&1
		eend $?
	else
		if [ -n "${SIGNER_BIN}" ]; then
			eerror "OpenDNSSEC Signer binary not executable"
			return 1
		fi
		einfo "OpenDNSSEC Signer not used."
	fi
}

stop_signer() {
	if [ -x "${SIGNER_BIN}" ]; then
		ebegin "Stopping OpenDNSSEC Signer"
		${CONTROL_BIN} signer stop > /dev/null 2>&1
		eend $?
	fi
}

start_eppclient() {
	if [ -n "${EPPCLIENT_BIN}" ] && [ -x "${EPPCLIENT_BIN}" ]; then
		ebegin "Starting OpenDNSSEC Eppclient"
		start-stop-daemon \
			--start \
			--user opendnssec --group opendnssec \
			--exec "${EPPCLIENT_BIN}" \
			--pidfile "${EPPCLIENT_PIDFILE}" > /dev/null
		eend $?
	else
		# eppclient is ofptional so if we use the default binary and it
		# is not used we won't die
		if [ -n "${EPPCLIENT_BIN}" ] && \
				[ "${EPPCLIENT_BIN}" != "/usr/sbin/eppclientd" ]; then
			eerror "OpenDNSSEC Eppclient binary not executable"
			return 1
		fi
		einfo "OpenDNSSEC Eppclient not used."
	fi
}

stop_eppclient() {
	if [ -x "${EPPCLIENT_BIN}" ]; then
		ebegin "Stopping OpenDNSSEC Eppclient"
		start-stop-daemon \
			--stop \
			--exec "${EPPCLIENT_BIN}" \
			--pidfile "${EPPCLIENT_PIDFILE}" > /dev/null
		eend $?
	fi
}

start() {
	checkconfig || return $?
	test -d /run/opendnssec || mkdir -p /run/opendnssec
	chown opendnssec:opendnssec /run/opendnssec
	start_enforcer || return $?
	start_signer || return $?
	start_eppclient || return $?
}

stop() {
	stop_eppclient
	stop_signer
	stop_enforcer
	sleep 5
}
