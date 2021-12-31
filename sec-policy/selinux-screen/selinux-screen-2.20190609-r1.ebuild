# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

IUSE=""
MODS="screen"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for screen"

if [[ ${PV} != 9999* ]] ; then
	KEYWORDS="~amd64 -arm ~arm64 ~mips ~x86"
fi
