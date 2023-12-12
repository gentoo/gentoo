# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xorg-3

DESCRIPTION="Xaw3dXft library"
HOMEPAGE="https://sourceforge.net/projects/sf-xpaint/"
SRC_URI="https://downloads.sourceforge.net/project/sf-xpaint/${PN,,}/${P}.tar.bz2"

KEYWORDS="~amd64 ~x86"
IUSE="xpm"

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
	app-alternatives/yacc
	x11-misc/util-macros"

QA_PKGCONFIG_VERSION="${PV//[!0-9.]}"

PATCHES=(
	"${FILESDIR}"/${P}-fix-gcc-14.patch
)

src_configure() {
	local XORG_CONFIGURE_OPTIONS=(
		$(usev xpm --enable-multiplane-bitmaps)

		--enable-internationalization
		--enable-arrow-scrollbars
		--enable-gray-stipples
	)
	xorg-3_src_configure
}
