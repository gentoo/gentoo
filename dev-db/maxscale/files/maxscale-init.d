#!/sbin/openrc-run

command=/usr/bin/maxscale
command_args="-U maxscale -P /run/maxscale"
name="MaxScale database proxy"
pidfile="/run/maxscale/maxscale.pid"

description="MaxScale provides database specific proxy functionality"
extra_started_commands="reload"

start_pre() {
	checkpath -D -o maxscale:maxscale /run/maxscale
}

reload()
{
	ebegin "Reloading ${name}"
	pkill -HUP -F /run/maxscale/maxscale.pid
	eend $?
}

