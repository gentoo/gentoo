# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

IUSE=""
MODS="chronyd"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for chronyd"

if [[ ${PV} != 9999* ]] ; then
	KEYWORDS="~amd64 -arm ~arm64 ~mips ~x86"
fi
