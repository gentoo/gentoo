# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="5"

IUSE=""
MODS="fail2ban"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for fail2ban"

if [[ ${PV} != 9999* ]] ; then
	KEYWORDS="amd64 x86"
fi
