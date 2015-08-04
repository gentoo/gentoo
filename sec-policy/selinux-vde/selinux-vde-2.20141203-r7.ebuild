# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-vde/selinux-vde-2.20141203-r7.ebuild,v 1.2 2015/08/04 16:49:38 perfinion Exp $
EAPI="5"

IUSE=""
MODS="vde"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for vde"

if [[ $PV == 9999* ]] ; then
	KEYWORDS=""
else
	KEYWORDS="amd64 x86"
fi
