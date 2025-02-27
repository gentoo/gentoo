# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License, v2 or later
#
if [ -f /run/openrc/softlevel ] && [ -z "$DBUS_SESSION_BUS_ADDRESS" ]
		&& rc-service --user --exists dbus 2>&1 >/dev/null; then
	export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"
fi
