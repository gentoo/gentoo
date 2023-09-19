#
# pre-shutdown script to abort shutdown in case noad is running

check_runtime() {
	local PID="$1"

	# Max runtime of 30m = 1800s
	local NOAD_MAX_TIME=1800
	local NOW="$(date +%s)"
	local START="$(stat --format "%Z" /proc/${PID}/)"
	local DIFF=$(( $NOW - $START ))
	if [ "${DIFF}" -ge "${NOAD_MAX_TIME}" ]; then
		kill ${PID}
		sleep 2
		kill -9 ${PID}
		return 0
	else
		# There still is a running noad process
		return 1
	fi
}

check_noad() {
	local PIDOF=pidof
	local NOAD=/usr/bin/noad

	local PIDS=$(${PIDOF} ${NOAD})
	local PID
	local still_running=0
	for PID in $PIDS; do
		check_runtime "${PID}"
		[ "$?" = "1" ] && still_running=1
	done

	if [ "${still_running}" -gt "0" ]; then
		# stop shutdown
		shutdown_abort_can_force "noad is running"
	fi
}

check_noad
