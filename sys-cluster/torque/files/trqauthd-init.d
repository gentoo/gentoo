#!/sbin/runscript
# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

depend() {
    need net
    after logger

    # 4.0+ only, make sure we run before the other torque services
    before pbs_mom
    before pbs_sched
    before pbs_server
}

start() {
    start-stop-daemon \
        --start \
        --exec /usr/sbin/trqauthd
}

stop() {
    start-stop-daemon \
        --stop \
        --exec /usr/sbin/trqauthd
}

