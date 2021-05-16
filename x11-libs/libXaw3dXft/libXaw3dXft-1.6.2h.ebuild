# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xorg-3

DESCRIPTION="Xaw3dXft library"
HOMEPAGE="https://sourceforge.net/projects/sf-xpaint"
SRC_URI="mirror://sourceforge/sf-xpaint/${P}.tar.bz2"

KEYWORDS="~amd64 ~x86"
IUSE="unicode xpm"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXft
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
		$(usex xpm "--enable-multiplane-bitmaps" "")
		--enable-arrow-scrollbars
		--enable-gray-stipples
	)
	xorg-3_src_configure
}
