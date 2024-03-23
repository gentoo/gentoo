# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_TARBALL_SUFFIX="xz"
inherit xorg-3

DESCRIPTION="X.Org Xaw3d library"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="xpm"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXt
	xpm? ( x11-libs/libXpm )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="
	app-alternatives/lex
	app-alternatives/yacc"

PATCHES=(
	"${FILESDIR}"/${PN}-1.6.5-c99.patch
)

src_configure() {
	local XORG_CONFIGURE_OPTIONS=(
		--enable-internationalization
		$(use_enable xpm multiplane-bitmaps)
		--enable-gray-stipples
		--enable-arrow-scrollbars
	)
	xorg-3_src_configure
}
