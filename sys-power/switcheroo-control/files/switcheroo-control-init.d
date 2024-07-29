#!/sbin/openrc-run

description="Switcheroo Control Proxy service"

command=/usr/libexec/switcheroo-control
command_background=yes
pidfile=/run/switcheroo-control.pid

depend() {
        need dbus
        before alsasound display-manager
}
