#!/sbin/runscript
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

depend() {
    need net redis
}

start() {
    ebegin "Starting ntopng"
    start-stop-daemon --start --exec /usr/bin/ntopng --pidfile /var/run/ntopng.pid --make-pidfile --background -e LUA_PATH='/usr/share/ntopng/scripts/lua/modules/?.lua' -- --user ntopng ${NTOPNG_OPTS}
    eend $?
}

stop() {
    ebegin "Stopping ntopng"
    start-stop-daemon --stop --exec /usr/bin/ntopng --pidfile /var/run/ntopng.pid
    eend $?
}
