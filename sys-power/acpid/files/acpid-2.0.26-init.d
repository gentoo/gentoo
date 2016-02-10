#!/sbin/openrc-run
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

extra_started_commands="reload"
command="/usr/sbin/acpid"
command_args="${ACPID_ARGS}"
description="Daemon for Advanced Configuration and Power Interface"

depend() {
	need localmount
	use logger
}

reload() {
	ebegin "Reloading acpid configuration"
	start-stop-daemon --exec $command --signal HUP
	eend $?
}
