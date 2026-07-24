# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xorg-meson

DESCRIPTION="X server resource database utility"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-solaris"

RDEPEND="
	x11-libs/libXmu
	x11-libs/libX11
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

src_configure() {
	local XORG_CONFIGURE_OPTIONS=(
		# needs full path so cannot use tc-getCPP, nor paths to clang-cpp
		# given would need a rebuild to update the path (bug #979049,#979489)
		-Dcpp="${EPREFIX}/usr/bin/${CHOST}-cpp,${EPREFIX}/usr/bin/cpp"
	)
	xorg-meson_src_configure
}
