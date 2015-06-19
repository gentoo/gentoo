#!/bin/sh
# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License, v2
# Author:  Martin Schlemmer <azarah@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xinit/files/chooser.sh,v 1.5 2009/11/14 14:18:43 scarabeus Exp $

# Find a match for $XSESSION in /etc/X11/Sessions
GENTOO_SESSION=""
for x in /etc/X11/Sessions/* ; do
	if [ "`echo ${x##*/} | awk '{ print toupper($1) }'`" \
		= "`echo ${XSESSION} | awk '{ print toupper($1) }'`" ]; then
		GENTOO_SESSION=${x}
		break
	fi
done

GENTOO_EXEC=""

if [ -n "${XSESSION}" ]; then
	if [ -f /etc/X11/Sessions/${XSESSION} ]; then
		if [ -x /etc/X11/Sessions/${XSESSION} ]; then
			GENTOO_EXEC="/etc/X11/Sessions/${XSESSION}"
		else
			GENTOO_EXEC="/bin/sh /etc/X11/Sessions/${XSESSION}"
		fi
	elif [ -n "${GENTOO_SESSION}" ]; then
		if [ -x "${GENTOO_SESSION}" ]; then
			GENTOO_EXEC="${GENTOO_SESSION}"
		else
			GENTOO_EXEC="/bin/sh ${GENTOO_SESSION}"
		fi
	else
		x=""
		y=""
		
		for x in "${XSESSION}" \
			"`echo ${XSESSION} | awk '{ print toupper($1) }'`" \
			"`echo ${XSESSION} | awk '{ print tolower($1) }'`"
		do
			# Fall through ...
			if [ -x "`which ${x} 2>/dev/null`" ]; then
				GENTOO_EXEC="`which ${x} 2>/dev/null`"
				break
			fi
		done
	fi
fi

echo "${GENTOO_EXEC}"


# vim:ts=4
