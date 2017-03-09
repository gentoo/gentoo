#!/sbin/openrc-run
# Copyright 1999-2017 Gentoo Foundation

description="The Common Unix Printing System daemon"
command="/usr/sbin/cupsd"
command_args="-f -c /etc/cups/cupsd.conf -s /etc/cups/cups-files.conf"
pidfile="/var/run/cupsd.pid"
start_stop_daemon_args="-b -m --pidfile ${pidfile}"

depend() {
	use net
	@neededservices@
	before nfs
	after logger
}

start_pre() {
	checkpath -q -d -m 0775 -o root:lp /var/cache/cups
	checkpath -q -d -m 0775 -o root:lp /var/cache/cups/rss
	checkpath -q -d -m 0755 -o root:lp /run/cups
	checkpath -q -d -m 0511 -o lp:lpadmin /run/cups/certs
}
