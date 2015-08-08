#!/sbin/runscript
# Copyright 1999-2014 Gentoo Foundation
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

	for ADDRESS in ${GALERA_NODES} 0; do
		HOST=$(echo $ADDRESS | cut -d \: -f 1 )
		PORT=$(echo $ADDRESS | cut -d \: -f 2 )
		if [ "x${HOST}" = "x${PORT}" ]; then
			PORT=${GALERA_PORT}
		fi
		PORT=${PORT:-$GALERA_PORT}
		nc -z ${HOST} ${PORT} > /dev/null &&  break
	done
	if [ ${ADDRESS} = "0" ]; then
		eerror "None of the nodes in GALERA_NODES is accessible"
		return 1
	fi

	OPTIONS="-a gcomm://${ADDRESS} -g ${GALERA_GROUP}"
	[ -n "${GALERA_OPTIONS}" ] && OPTIONS="${OPTIONS} -o ${GALERA_OPTIONS}"
        [ -n "${LOG_FILE}" ]       && OPTIONS="${OPTIONS} -l ${LOG_FILE}"

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

