#!/sbin/openrc-run
# Copyright (c) 2009 Roy Marples <roy@marples.name>
# All rights reserved. Released under the 2-clause BSD license.

command=/usr/sbin/wpa_supplicant
: ${wpa_supplicant_conf:=/etc/wpa_supplicant/wpa_supplicant.conf}
wpa_supplicant_if=${wpa_supplicant_if:+-i}$wpa_supplicant_if
command_args="$wpa_supplicant_args -B -c$wpa_supplicant_conf $wpa_supplicant_if"
name="WPA Supplicant Daemon"

depend()
{
	need localmount
	use logger
	after bootmisc modules
	before dns dhcpcd net
	keyword -shutdown
}

find_wireless()
{
	local iface=

	case "$RC_UNAME" in
	Linux)
		for iface in /sys/class/net/*; do
			if [ -e "$iface"/wireless -o \
				-e "$iface"/phy80211 ]
			then
				echo "${iface##*/}"
				return 0
			fi
		done
		;;
	*)
		for iface in /dev/net/* $(ifconfig -l 2>/dev/null); do
			if ifconfig "${iface##*/}" 2>/dev/null | \
				grep -q "[ ]*ssid "
			then
				echo "${iface##*/}"
				return 0
			fi
		done
		;;
	esac
	
	return 1
}

append_wireless()
{
	local iface= i=

	iface=$(find_wireless)
	if [ -n "$iface" ]; then
		for i in $iface; do
			command_args="$command_args -i$i"
		done
	else
		eerror "Could not find a wireless interface"
	fi
}

start_pre()
{
	case " $command_args" in
	*" -i"*) ;;
	*) append_wireless;;
	esac
}
