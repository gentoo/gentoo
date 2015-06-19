#!/sbin/runscript
# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/watchdog/files/watchdog-init.d,v 1.3 2010/08/24 21:01:50 vapier Exp $

depend() {
	need localmount
	use logger
}

get_config() {
	set -- ${WATCHDOG_OPTS}
	while [ -n "$1" ] ; do
		if [ "$1" = "-c" -o "$1" = "--config-file" ] ; then
			echo $2
			return
		fi
		shift
	done
	echo /etc/watchdog.conf
}

get_delay() {
	# man this is fugly
	sed -n \
		-e '1{x;s:.*:10:;x}' \
		-e 's:#.*::' \
		-e 's:^[[:space:]]*::' \
		-e '/^interval/{s:.*=::;h}' \
		-e '${g;p}' \
		$(get_config)
}

start() {
	ebegin "Starting watchdog"
	start-stop-daemon --start \
		--exec /usr/sbin/watchdog --pidfile /var/run/watchdog.pid \
		-- ${WATCHDOG_OPTS}
	eend $?
}

stop() {
	ebegin "Stopping watchdog"
	start-stop-daemon --stop \
		--exec /usr/sbin/watchdog --pidfile /var/run/watchdog.pid \
		--retry $(get_delay)
	eend $?
}
