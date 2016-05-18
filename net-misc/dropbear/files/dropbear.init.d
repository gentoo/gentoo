#!/sbin/openrc-run
# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

depend() {
	use logger dns
	need net
}

check_config() {
	mkdir -p /etc/dropbear

	local t k
	for t in dss rsa ecdsa; do
		k="/etc/dropbear/dropbear_${t}_host_key"
		if [ ! -e ${k} ] ; then
			# See if support is enabled for this key type.
			if dropbearkey -h 2>&1 | grep -q "	${t}$" ; then
				einfo "Generating ${k} ..."
				dropbearkey -t ${t} -f ${k} >/dev/null
			fi
		fi &
	done
	wait
}

start() {
	check_config || return 1
	ebegin "Starting dropbear"
	dropbear ${DROPBEAR_OPTS}
	eend $?
}

stop() {
	ebegin "Stopping dropbear"
	start-stop-daemon --stop --pidfile /var/run/dropbear.pid
	eend $?
}
