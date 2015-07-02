# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-nut/selinux-nut-2.20141203-r7.ebuild,v 1.1 2015/07/02 17:59:33 perfinion Exp $
EAPI="5"

IUSE=""
MODS="nut"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for nut"

if [[ $PV == 9999* ]] ; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi
DEPEND="${DEPEND}
	sec-policy/selinux-apache
"
RDEPEND="${RDEPEND}
	sec-policy/selinux-apache
"
