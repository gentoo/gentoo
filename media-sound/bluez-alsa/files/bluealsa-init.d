#!/sbin/openrc-run
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

pidfile="/var/run/bluealsa.pid"
command="/usr/bin/bluealsa"
command_args="--disable-hsp"
command_background="true"

depend() {
	after bluetooth
	need dbus localmount
}

start_pre() {
	checkpath -q -D -m 0770 -o :audio /var/run/bluealsa
}
