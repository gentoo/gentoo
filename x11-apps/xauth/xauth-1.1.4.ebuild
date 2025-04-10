# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xorg-3

DESCRIPTION="X authority file utility"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXext
	x11-libs/libXmu"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

XORG_CONFIGURE_OPTIONS=(
	--enable-ipv6
)
