# Copyright (c) 2016 Gentoo Foundation
# All rights reserved. Released under the 2-clause BSD license.

wireguard_depend()
{
	program /usr/bin/wg
	after interface
	before dhcp
}

wireguard_pre_start()
{
	ip link delete dev "$IFACE" type wireguard 2>/dev/null
	ebegin "Creating WireGuard interface $IFACE"
	if ! ip link add dev "$IFACE" type wireguard; then
		eend $?
		return $?
	fi
	eend 0

	ebegin "Configuring WireGuard interface $IFACE"
	set -- $(_get_array "wireguard_$IFVAR")
	if [[ -f $1 && $# -eq 1 ]]; then
		/usr/bin/wg setconf "$IFACE" "$1"
	else
		eval /usr/bin/wg set "$IFACE" "$@"
	fi
	if [ $? -eq 0 ]; then
		_up
		eend 0
		return
	fi
	e=$?
	ip link delete dev "$IFACE" type wireguard 2>/dev/null
	eend $e
}

wireguard_post_stop()
{
	ebegin "Removing WireGuard interface $IFACE"
	ip link delete dev "$IFACE" type wireguard
	eend $?
}
