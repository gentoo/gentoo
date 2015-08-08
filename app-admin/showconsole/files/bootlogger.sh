# /lib/rcscripts/addons/bootlogger.sh:  Handle logging of output at boot
# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

if [[ -x /sbin/blogd ]] ; then

bootlog() {
	[[ ${RC_BOOTLOG} == "yes" ]] || return 0

	local opt=$1
	shift
	case ${opt} in
	start) blogd_start "$@";;
	sync)  blogd_sync "$@";;
	quit)  blogd_quit "$@";;
	esac
}

blogd_start() {
	/sbin/blogd -q
}

blogd_sync() {
	echo > /var/log/boot.msg
	killall -IO blogd
}

blogd_quit() {
	killall -QUIT blogd
}

fi
