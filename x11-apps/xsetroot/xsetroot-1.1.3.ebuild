# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_TARBALL_SUFFIX="xz"
inherit xorg-3

DESCRIPTION="X.Org xsetroot application"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXmu
	x11-misc/xbitmaps"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
