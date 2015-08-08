#!/sbin/runscript
# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

PIDFILE=/var/run/teeworlds.pid
GAME_DIRECTORY=/usr/games/bin
CONFIG=/etc/teeworlds/teeworlds_srv.cfg

depend() {
	use dns logger net
}

checkconfig() {
        if [ ! -e ${CONFIG} ] ; then
                eerror "You need an ${CONFIG} config file to run TeeWorlds"
                return 1
        fi
}

start() {
	ebegin "Starting TeeWorlds"
	start-stop-daemon --start --background --pidfile "${PIDFILE}" \
		--make-pidfile -d ${GAME_DIRECTORY} --user games \
		--exec ${GAME_DIRECTORY}/teeworlds_srv -- -f ${CONFIG}
	eend $?
}

reload() {
	ebegin "Reloading TeeWorlds configs and restarting processes"
	start-stop-daemon --stop --oknodo --user games \
    		--pidfile "${PIDFILE}" --signal HUP \
		--exec ${GAME_DIRECTORY}/teeworlds_srv -- -f ${CONFIG}
	eend $?
}

stop() {
	ebegin "Stopping TeeWorlds"
	start-stop-daemon --stop --quiet --pidfile "${PIDFILE}"
	eend $?
}
