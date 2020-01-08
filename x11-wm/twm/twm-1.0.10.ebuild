# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

XORG_STATIC=no
inherit xorg-2

DESCRIPTION="X.Org Tab Window Manager"

KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXt
	x11-libs/libXmu
	x11-libs/libICE
	x11-libs/libSM"
DEPEND="${RDEPEND}
	sys-devel/bison"
