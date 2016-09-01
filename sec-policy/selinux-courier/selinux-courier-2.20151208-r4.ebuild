# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="5"

IUSE=""
MODS="courier"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for courier"

if [[ ${PV} != 9999* ]] ; then
	KEYWORDS="amd64 ~arm ~arm64 ~mips x86"
fi
