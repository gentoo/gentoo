# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

IUSE=""
MODS="dropbox"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for dropbox"

if [[ ${PV} != 9999* ]] ; then
	KEYWORDS="amd64 -arm ~arm64 ~mips x86"
fi
DEPEND="${DEPEND}
	sec-policy/selinux-xserver
	sec-policy/selinux-dbus
"
RDEPEND="${RDEPEND}
	sec-policy/selinux-xserver
	sec-policy/selinux-dbus
"
