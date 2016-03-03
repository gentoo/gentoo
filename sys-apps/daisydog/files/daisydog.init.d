#!/sbin/runscript
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

command="/usr/bin/daisydog"
command_args="${WATCHDOG_OPTS}"
description="watchdog daemon to pet /dev/watchdog devices"
start_stop_daemon_args="--make-pidfile --background --pidfile /run/daisydog.pid"

depend() {
	provide watchdog
}
