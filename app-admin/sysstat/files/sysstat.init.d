#!/sbin/openrc-run
# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

depend() {
    use hostname
}

start() {
    ebegin "Writing a dummy startup record using sadc (see sadc(8))..."
    /usr/lib/sa/sa1 --boot
    eend $?
}

stop() {
    ebegin "Cannot stop writing a dummy startup record (see sadc(8))..."
    eend $?
}
