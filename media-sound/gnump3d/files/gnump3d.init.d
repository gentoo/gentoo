#!/sbin/runscript
# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

extra_commands="index"

depend() {
	need net
	after netmount nfsmount
}

start() {
	ebegin "Starting gnump3d"

	if [ ${DO_INDEX} -eq 1 ]; then
		ebegin "Updating index of music files (may take a while for the first time)"
		/usr/bin/gnump3d-index
		eend $?
	fi

	start-stop-daemon --start --quiet --exec /usr/bin/gnump3d2 --make-pidfile \
		--pidfile /var/run/gnump3d.pid --background -- --quiet
	eend $?
}

stop() {
	ebegin "Stopping gnump3d"
	start-stop-daemon --stop --quiet --pidfile /var/run/gnump3d.pid
	eend $?
}

index() {
	ebegin "Indexing music files"
	/usr/bin/gnump3d-index
	eend $?
}
