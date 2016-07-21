#!/sbin/openrc-run

PIDFILE=/var/run/cups-browsed.pid

depend() {
	need cupsd avahi-daemon
}

start() {
	ebegin "Starting cups-browsed"
	start-stop-daemon --start --make-pidfile --pidfile "${PIDFILE}" \
		--background --quiet --exec /usr/sbin/cups-browsed
	eend $?
}

stop() {
	ebegin "Stopping cups-browsed"
	start-stop-daemon --stop --pidfile "${PIDFILE}" --quiet --exec /usr/sbin/cupsd
	eend $?
}
