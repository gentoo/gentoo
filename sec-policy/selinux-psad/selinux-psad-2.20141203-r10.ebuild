# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="5"

IUSE=""
MODS="psad"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for psad"

if [[ ${PV} != 9999* ]] ; then
	KEYWORDS="amd64 x86"
fi
