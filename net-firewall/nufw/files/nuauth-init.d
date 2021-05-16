#!/sbin/openrc-run

depend() {
	before net
}

checkconfig() {
	if [ ! -e /etc/nufw/nuauth.conf ]; then
		eerror "You need a /etc/nufw/nuauth.conf file to run nuauth"
		eerror "There is sample file in /usr/share/doc/nufw-version/"
		return 1
	fi
}

start() {
	checkpath -d /run/nuauth
	checkconfig || return 1
	ebegin "Starting nuauth"
		start-stop-daemon --start --quiet --exec /usr/sbin/nuauth -- -D ${NUAUTH_OPTIONS}
	eend $?
}

stop() {
	ebegin "Stopping nuauth"
		start-stop-daemon --stop --quiet --pidfile /run/nuauth/nuauth.pid
	eend $?
}
