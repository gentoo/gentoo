# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-dkim/selinux-dkim-2.20141203-r7.ebuild,v 1.2 2015/08/04 16:49:33 perfinion Exp $
EAPI="5"

IUSE=""
MODS="dkim"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for dkim"

if [[ $PV == 9999* ]] ; then
	KEYWORDS=""
else
	KEYWORDS="amd64 x86"
fi

DEPEND="${DEPEND}
	sec-policy/selinux-milter
"
RDEPEND="${RDEPEND}
	sec-policy/selinux-milter
"
