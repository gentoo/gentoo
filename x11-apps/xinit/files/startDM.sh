#!/bin/sh
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License, v2

# We need to source /etc/profile for stuff like $LANG to work
# bug #10190.
. /etc/profile

. /lib/rc/sh/functions.sh

# Bail out early if on a non-OpenRC system:
if [ ! -d /run/openrc ]; then
	eerror "$0 should only be used on OpenRC systems"
fi

# baselayout-1 compat
if ! type get_options >/dev/null 2>/dev/null ; then
	[ -r "${svclib}"/sh/rc-services.sh ] && . "${svclib}"/sh/rc-services.sh
fi

export RC_SVCNAME=xdm
EXEC="$(get_options service)"
NAME="$(get_options name)"
PIDFILE="$(get_options pidfile)"
START_STOP_ARGS="$(get_options start_stop_args)"

start-stop-daemon --start --exec ${EXEC} \
${NAME:+--name} ${NAME} ${PIDFILE:+--pidfile} ${PIDFILE} ${START_STOP_ARGS} || \
eerror "ERROR: could not start the Display Manager"

# vim:ts=4
