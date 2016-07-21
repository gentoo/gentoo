# Copyright (c) 2004-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Contributed by Sven Wegener (swegener@gentoo.org)

# void autoipd_depend(void)
#
# Sets up the dependencies for the module
autoipd_depend() {
	after interface
}

# void autoipd_expose(void)
#
# Expose variables that can be configured
autoipd_expose() {
	variables autoipd
}

# bool autoipd_start(char *iface)
#
# Tries to configure the interface via avahi-autoipd
autoipd_start() {
	local iface="${1}" ifvar="$(bash_variable "${iface}")" opts="autoipd_${ifvar}" addr=""

	interface_exists "${iface}" true || return 1

	ebegin "Starting avahi-autoipd"
	if /usr/sbin/avahi-autoipd --daemonize --syslog --wait ${!opts} "${iface}"
	then
			eend 0
			addr="$(interface_get_address "${iface}")"
			einfo "${iface} received address ${addr}"
			return 0
	fi

	eend "${?}" "Failed to get address via avahi-autoipd!"
}

# bool autoipd_stop(char *iface)
#
# Stops a running avahi-autoipd instance
autoipd_stop() {
	local iface="${1}"

	/usr/sbin/avahi-autoipd --check --syslog "${iface}" || return 0

	ebegin "Stopping avahi-autoipd"
	/usr/sbin/avahi-autoipd --kill --syslog "${iface}"
	eend "${?}" "Failed to stop running avahi-autoipd instance!"
}

# vim: set ts=4 :
