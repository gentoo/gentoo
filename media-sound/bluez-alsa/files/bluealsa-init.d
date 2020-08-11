#!/sbin/openrc-run
# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

pidfile="/var/run/bluealsa.pid"
command="/usr/bin/bluealsa"
command_args="${BLUEALSA_CONF}"
command_background="true"

depend() {
	after bluetooth
	need dbus localmount
}

start_pre() {
	checkpath -q -D -m 0770 -o :audio /var/run/bluealsa
}
