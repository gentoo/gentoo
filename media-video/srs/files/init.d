#!/sbin/openrc-run
# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

description="SRS (Simple Realtime Server) media streaming server"

extra_started_commands="reload rotate grace"

description_reload="Reload SRS configuration smoothly using SIGHUP"
description_rotate="Reopen log files for logrotate using SIGUSR1"
description_grace="Gracefully quit SRS using SIGQUIT"

depend() {
	need net
	after firewall
}

start() {
	ebegin "Starting SRS"
	
	start-stop-daemon --start \
		--exec /usr/bin/srs-media \
		--pidfile "${SRS_PIDFILE:-/run/srs.pid}" \
		${SRS_EXTRA_OPTS} \
		-- -c "${SRS_CONFIG:-/etc/srs/srs.conf}"
	eend $?
}

stop() {
	ebegin "Stopping SRS"
	start-stop-daemon --stop \
		--retry SIGTERM/30/SIGKILL/5 \
		--pidfile "${SRS_PIDFILE:-/run/srs.pid}"
	eend $?
}

reload() {
	ebegin "Reloading SRS configuration"
	start-stop-daemon --signal SIGHUP --pidfile "${SRS_PIDFILE:-/run/srs.pid}"
	eend $?
}

rotate() {
	ebegin "Reopening SRS log files"
	start-stop-daemon --signal SIGUSR1 --pidfile "${SRS_PIDFILE:-/run/srs.pid}"
	eend $?
}

grace() {
	ebegin "Gracefully quitting SRS"
	start-stop-daemon --signal SIGQUIT --pidfile "${SRS_PIDFILE:-/run/srs.pid}"
	eend $?
}
