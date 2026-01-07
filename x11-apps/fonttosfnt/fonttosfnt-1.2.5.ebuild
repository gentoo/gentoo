# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xorg-3

DESCRIPTION="X.Org fonttosfnt application"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="media-libs/freetype:2
	x11-libs/libX11
	x11-libs/libfontenc"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
