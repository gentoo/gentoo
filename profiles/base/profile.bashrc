# Copyright 2006-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

if ! declare -F elog >/dev/null ; then
	elog() {
		einfo "$@"
	}
fi
