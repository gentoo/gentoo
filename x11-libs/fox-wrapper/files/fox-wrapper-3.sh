#!/bin/bash
# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# Based on the am-wrapper.sh script (sys-devel/automake-wrapper-1-r1)
#
# Executes the correct fox-config version, based on the value of WANT_FOX.
# All versions of fox after 1.0.x ship with a fox-config script
#
#
# Stable branches first, in descending order, then unstable branches.
# After a new stable branch, prepend the new version and bump (or remove)
# the last unstable branch
#
vers="1.6 1.4 1.7"
bindir=/usr/bin

if [ "${0##*/}" = "fox-wrapper.sh" ] ; then
	echo "fox-wrapper: Don't call this script directly, use fox-config instead" >&2
	exit 1
fi

if [ -z "${WANT_FOX}" ] ; then
	echo "fox-wrapper: Set the WANT_FOX variable to the desired version of fox, e.g.:" >&2
	echo "             WANT_FOX=\"1.6\" fox-config $@"
	exit 1
fi

for v in ${vers} ; do
	eval binary_${v/./_}="fox-${v}-config"
done

#
# Check the WANT_FOX setting
#
for v in ${vers} x ; do
	if [ "${v}" = "x" ] ; then
		echo "fox-wrapper: WANT_FOX was set to an invalid version ${WANT_FOX}" >&2
		echo "             Valid values of WANT_FOX are: ${vers// /, }"
		exit 1
	fi

	if [ "${WANT_FOX}" = "${v}" ] ; then
		binary="binary_${v/./_}"
		binary="${!binary}"
		break
	fi
done

if [ "${WANT_FOXWRAPPER_DEBUG}" ] ; then
	echo "fox-wrapper: DEBUG: WANT_FOX is set to ${WANT_FOX}" >&2
	echo "fox-wrapper: DEBUG: will execute <$binary>" >&2
fi

#
# for further consistency
#
for v in ${vers} ; do
	mybin="binary_${v/./_}"
	if [ "${binary}" = "${!mybin}" ] ; then
		export WANT_FOX="${v}"
	fi
done

#
# Now try to run the binary
#
if [ ! -x "${bindir}/${binary}" ] ; then
	echo "fox-wrapper: $binary is missing or not executable." >&2
	echo "             Please try emerging the correct version of fox, i.e.:" >&2
	echo "             emerge '=x11-libs/${binary/-config/}*'" >&2
	exit 1
fi

"$binary" "$@"
