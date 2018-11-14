#!/bin/sh
# Copyright (c) 2006-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Contributed by Roy Marples (uberlord@gentoo.org)

# If we have a service specific script, run this now
if [ -x /etc/openvpn/"${SVCNAME}"-down.sh ] ; then
	/etc/openvpn/"${SVCNAME}"-down.sh "$@"
fi

# Restore resolv.conf to how it was
if [ "${PEER_DNS}" != "no" ]; then
	if [ -x /sbin/resolvconf ] ; then
		/sbin/resolvconf -d "${dev}"
	elif [ -e /etc/resolv.conf-"${dev}".sv ] ; then
		# Important that we copy instead of move incase resolv.conf is
		# a symlink and not an actual file
		cp /etc/resolv.conf-"${dev}".sv /etc/resolv.conf
		rm -f /etc/resolv.conf-"${dev}".sv
	fi
fi

if [ -n "${SVCNAME}" ]; then
	# Re-enter the init script to start any dependant services
	if /etc/init.d/"${SVCNAME}" --quiet status ; then
		export IN_BACKGROUND=true
		/etc/init.d/"${SVCNAME}" --quiet stop
	fi
fi

exit 0

# vim: ts=4 :
