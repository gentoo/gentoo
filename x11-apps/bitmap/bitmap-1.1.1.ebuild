# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_TARBALL_SUFFIX=xz
inherit xorg-3

DESCRIPTION="X.Org bitmap application"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXmu
	x11-libs/libXt
	x11-misc/xbitmaps"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
