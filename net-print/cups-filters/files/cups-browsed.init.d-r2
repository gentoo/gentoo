#!/sbin/openrc-run

pidfile="/run/cups-browsed.pid"
command="/usr/sbin/cups-browsed"
command_background="true"

depend() {
	need cupsd avahi-daemon
}
