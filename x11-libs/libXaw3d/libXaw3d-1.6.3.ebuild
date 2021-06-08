# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xorg-3

DESCRIPTION="X.Org Xaw3d library"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris ~x86-solaris"
IUSE="unicode xpm"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXt
	xpm? ( x11-libs/libXpm )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="
	sys-devel/flex
	virtual/yacc"

src_configure() {
	local XORG_CONFIGURE_OPTIONS=(
		$(use_enable unicode internationalization)
		$(use_enable xpm multiplane-bitmaps)
		--enable-arrow-scrollbars
		--enable-gray-stipples
	)
	xorg-3_src_configure
}
