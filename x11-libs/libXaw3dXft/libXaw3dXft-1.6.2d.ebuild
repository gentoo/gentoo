# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit xorg-2

DESCRIPTION="Xaw3dXft library"
HOMEPAGE="https://sourceforge.net/projects/sf-xpaint"
SRC_URI="mirror://sourceforge/sf-xpaint/${P}.tar.bz2"

KEYWORDS="~amd64 ~x86"
IUSE="unicode xpm"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXft
	x11-libs/libXmu
	x11-libs/libXt
	xpm? ( x11-libs/libXpm )"
DEPEND="${RDEPEND}
	sys-devel/flex
	virtual/yacc
	x11-proto/xextproto
	x11-proto/xproto"

pkg_setup() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable unicode internationalization)
		$(usex xpm "--enable-multiplane-bitmaps" "")
		--enable-arrow-scrollbars
		--enable-gray-stipples
	)

	xorg-2_pkg_setup
}
