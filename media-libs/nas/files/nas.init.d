#!/sbin/openrc-run

depend() {
	need net
	after alsasound esd
}

start() {
	ebegin "Starting nas"
	start-stop-daemon --start --quiet --exec /usr/bin/nasd --background \
		--pidfile /var/run/nasd.pid --make-pidfile -- $NAS_OPTIONS
	eend $?
}

stop() {
	ebegin "Stopping nas"
	start-stop-daemon --stop --quiet --pidfile /var/run/nasd.pid
	eend $?
}
