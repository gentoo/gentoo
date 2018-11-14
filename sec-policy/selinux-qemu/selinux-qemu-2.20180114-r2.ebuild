# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

IUSE=""
MODS="qemu"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for qemu"

if [[ ${PV} != 9999* ]] ; then
	KEYWORDS="amd64 -arm ~arm64 ~mips x86"
fi
DEPEND="${DEPEND}
	sec-policy/selinux-virt
"
RDEPEND="${RDEPEND}
	sec-policy/selinux-virt
"
