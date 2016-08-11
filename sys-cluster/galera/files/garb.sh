#!/sbin/openrc-run
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

depend() {
	use net
	after mysql
}

start() {
	ebegin "Starting ${SVCNAME}"

	if [ -z "${GALERA_NODES}" ]; then
		eerror "List of GALERA_NODES is not configured"
		return 1
	fi

	if [ -z "${GALERA_GROUP}" ]; then
		eerror "GALERA_GROUP name is not configured"
		return 1
	fi

	GALERA_PORT="${GALERA_PORT:-4567}"

	OPTIONS="-a gcomm://${GALERA_NODES// /,} -g ${GALERA_GROUP}"
	[ -n "${GALERA_OPTIONS}" ] && OPTIONS="${OPTIONS} -o ${GALERA_OPTIONS}"
	[ -n "${LOG_FILE}" ]       && OPTIONS="${OPTIONS} -l ${LOG_FILE}"
	[ -n "${NODE_NAME}" ]      && OPTIONS="${OPTIONS} -n ${NODE_NAME}"

	start-stop-daemon \
		--start \
		--exec /usr/bin/garbd \
		--pidfile "${PIDFILE}" \
		--make-pidfile \
		--user garbd \
		--group garbd \
		--background \
		-- ${OPTIONS}
	eend $?
}

stop() {
	ebegin "Stopping ${SVCNAME}"
	start-stop-daemon \
		--stop \
		--exec /usr/bin/garbd \
		--pidfile "${PIDFILE}"
	eend $?
}
