# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="onscreen soft keyboard for X11"
HOMEPAGE="http://trac.hackable1.org/trac/wiki/Xkbd"
SRC_URI="http://trac.hackable1.org/trac/raw-attachment/wiki/Xkbd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~x86"
IUSE="debug"

RDEPEND="x11-libs/libXrender
	x11-libs/libX11
	x11-libs/libXft
	x11-libs/libXtst
	x11-libs/libXpm
	media-libs/freetype
	dev-libs/expat
	sys-libs/zlib"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto"

DOCS=( AUTHORS )
PATCHES=(
	"${FILESDIR}"/${P}-fix-geometry.patch
	"${FILESDIR}"/${P}-desktop.patch
	"${FILESDIR}"/${PN}-0.8.15-increase-delay.patch
	"${FILESDIR}"/${PN}-0.8.15-fix-keysyms-search.patch
)

src_configure() {
	econf \
		$(use_enable debug)
}
