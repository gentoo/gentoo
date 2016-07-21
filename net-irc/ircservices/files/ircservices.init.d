#!/sbin/openrc-run
# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License, v2 or later
# $Id$

depend() {
	if [[ ${LOCALIRCD} = true ]]
	then
		need net ircd
	else
		need net
		use ircd
	fi
}

start() {
	ebegin "Starting IRC Services"
	start-stop-daemon --start --quiet --user ircservices --exec /usr/bin/ircservices -- \
		-dir=/var/lib/ircservices \
		-log=/var/log/ircservices/ircservices.log \
		&>/dev/null
	eend $?
}

stop() {
	ebegin "Stopping IRC Services"
	start-stop-daemon --stop --quiet --pidfile /var/lib/ircservices/ircservices.pid
	eend $?
	rm -f /var/lib/ircservices/ircservices.pid
}
