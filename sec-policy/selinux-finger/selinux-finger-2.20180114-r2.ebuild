# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

IUSE=""
MODS="finger"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for finger"

if [[ ${PV} != 9999* ]] ; then
	KEYWORDS="amd64 -arm ~arm64 ~mips x86"
fi

DEPEND="${DEPEND}
	sec-policy/selinux-inetd
"
RDEPEND="${RDEPEND}
	sec-policy/selinux-inetd
"
