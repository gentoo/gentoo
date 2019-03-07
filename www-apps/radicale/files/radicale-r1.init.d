#!/sbin/openrc-run
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

PIDFILE=/var/run/radicale.pid

depend() {
    use net
    need localmount
}

start() {
    ebegin "Starting radicale"
        start-stop-daemon --start --quiet --background \
        --user radicale \
        --stderr-logger /usr/bin/logger \
        --pidfile ${PIDFILE} --make-pidfile \
        --exec /usr/bin/radicale -- --foreground
    eend $?
}

stop() {
    ebegin "Stopping radicale"
        start-stop-daemon --stop --quiet \
        --pidfile ${PIDFILE}
    eend $?
}
