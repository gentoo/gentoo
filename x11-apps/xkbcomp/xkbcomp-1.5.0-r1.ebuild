# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xorg-meson

DESCRIPTION="XKB keyboard description compiler"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	>=x11-libs/libX11-1.6.9
	x11-libs/libxkbfile"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="app-alternatives/yacc"

src_configure() {
	local XORG_CONFIGURE_OPTIONS=(
		-Dxkb-config-root="${ESYSROOT}/usr/share/X11/xkb"
	)

	xorg-meson_src_configure
}
