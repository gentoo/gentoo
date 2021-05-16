#!/sbin/openrc-run

depend() {
	before net
}

start() {
	ebegin "Starting nufw"
	start-stop-daemon --start --quiet --exec /usr/sbin/nufw -- -D ${NUFW_OPTIONS}
	eend $?
}

stop() {
	ebegin "Stopping nufw"
	start-stop-daemon --stop --quiet --pidfile /run/nufw.pid
	eend $?
}
