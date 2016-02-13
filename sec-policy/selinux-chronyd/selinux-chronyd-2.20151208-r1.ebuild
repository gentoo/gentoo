# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="5"

IUSE=""
MODS="chronyd"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for chronyd"

if [[ $PV == 9999* ]] ; then
	KEYWORDS=""
else
	KEYWORDS="amd64 x86"
fi
