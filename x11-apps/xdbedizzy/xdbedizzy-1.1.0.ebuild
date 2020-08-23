# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit xorg-2

DESCRIPTION="X.Org xdbedizzy application"
KEYWORDS="amd64 arm ~mips ppc ppc64 s390 ~sparc x86"
IUSE=""

RDEPEND="
	x11-libs/libXext
	x11-libs/libX11
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
"
