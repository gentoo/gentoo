#!/sbin/openrc-run
# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

name="bgpd daemon"
description="OpenBGPD is a free implementation of BGPv4"
command=/usr/sbin/bgpd
command_args="${BGPD_OPTS}"

extra_started_commands="reload"

depend() {
	use net
	use logger
}

reload() {
	${command} -n || return 1
	ebegin "Reloading bgpd"
	/usr/sbin/bgpctl reload
	eend $?
}
