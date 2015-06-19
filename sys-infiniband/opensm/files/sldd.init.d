#!/sbin/runscript
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-infiniband/opensm/files/sldd.init.d,v 1.1 2015/02/11 04:45:41 bircoph Exp $

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

