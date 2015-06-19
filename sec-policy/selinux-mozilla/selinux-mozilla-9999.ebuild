# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-mozilla/selinux-mozilla-9999.ebuild,v 1.6 2015/03/22 13:47:27 swift Exp $
EAPI="5"

IUSE="alsa"
MODS="mozilla"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for mozilla"

if [[ $PV == 9999* ]] ; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi
DEPEND="${DEPEND}
	sec-policy/selinux-xserver
"
RDEPEND="${RDEPEND}
	sec-policy/selinux-xserver
"
