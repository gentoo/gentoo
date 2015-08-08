#!/sbin/runscript
# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

depend() {
        use net
        after dns dsmc
}

start() {
        ebegin "Starting dsmcad"
        start-stop-daemon --start --background --nicelevel 15 \
                --make-pidfile --pidfile /var/run/dsmcad.pid \
                --exec /opt/tivoli/tsm/client/ba/bin/dsmcad
        eend $?
}

stop() {
        ebegin "Stopping dsmcad"
        start-stop-daemon --stop \
                --signal 1 \
                --pidfile /var/run/dsmcad.pid
        eend $?
}
