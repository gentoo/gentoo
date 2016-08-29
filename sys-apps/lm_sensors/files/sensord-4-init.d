#!/sbin/openrc-run
# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

CONFIG=/etc/sensors3.conf

depend() {
	need localmount
	use logger lm_sensors
}

pidfile=/run/sensord.pid
command=/usr/sbin/sensord
command_args="--config-file ${CONFIG} ${SENSORD_OPTIONS} --pid-file ${pidfile}"

start_pre() {
	if [ ! -f ${CONFIG} ]; then
		eerror "Configuration file ${CONFIG} not found"
		return 1
	fi
}
