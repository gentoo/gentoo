#!/sbin/openrc-run
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

depend() {
    need opensm
    after net    # ip net seems to be needed to perform management.
}

prog=/usr/sbin/sldd.sh
pidfile=/var/run/sldd.pid

start() {
    ebegin "Starting Semi-static LID OpenSM Distribution Manager"
    start-stop-daemon --start --background --pidfile "${pidfile}" \
        --make-pidfile --wait 500 --exec $prog
    eend $?
}

stop() {
    ebegin "Stopping OpenSM Infiniband Subnet Manager"
    start-stop-daemon --stop --pidfile "${pidfile}"
    eend $?
}

