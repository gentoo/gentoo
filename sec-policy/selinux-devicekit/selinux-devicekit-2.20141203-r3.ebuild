# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-devicekit/selinux-devicekit-2.20141203-r3.ebuild,v 1.2 2015/03/22 14:17:09 swift Exp $
EAPI="5"

IUSE=""
MODS="devicekit"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for devicekit"

if [[ $PV == 9999* ]] ; then
	KEYWORDS=""
else
	KEYWORDS="amd64 x86"
fi

DEPEND="${DEPEND}
	sec-policy/selinux-dbus
"
RDEPEND="${RDEPEND}
	sec-policy/selinux-dbus
"
