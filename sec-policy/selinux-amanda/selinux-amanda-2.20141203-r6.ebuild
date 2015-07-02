# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-amanda/selinux-amanda-2.20141203-r6.ebuild,v 1.2 2015/07/02 18:06:57 perfinion Exp $
EAPI="5"

IUSE=""
MODS="amanda"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for amanda"

if [[ $PV == 9999* ]] ; then
	KEYWORDS=""
else
	KEYWORDS="amd64 x86"
fi
DEPEND="${DEPEND}
	sec-policy/selinux-inetd
"
RDEPEND="${RDEPEND}
	sec-policy/selinux-inetd
"
