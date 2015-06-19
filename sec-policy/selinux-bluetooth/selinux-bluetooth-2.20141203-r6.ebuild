# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-bluetooth/selinux-bluetooth-2.20141203-r6.ebuild,v 1.1 2015/06/05 15:57:20 perfinion Exp $
EAPI="5"

IUSE=""
MODS="bluetooth"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for bluetooth"

if [[ $PV == 9999* ]] ; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi
