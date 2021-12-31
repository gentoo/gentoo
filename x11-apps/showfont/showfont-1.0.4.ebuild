# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit xorg-2

DESCRIPTION="font dumper for X font server"
KEYWORDS="amd64 arm ~mips ppc ppc64 ~s390 sparc x86"
IUSE=""

RDEPEND="x11-libs/libFS"
DEPEND="${RDEPEND}"
