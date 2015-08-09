# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="an automotive simulation framework"
HOMEPAGE="http://vamos.sourceforge.net/"
SRC_URI="mirror://sourceforge/vamos/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs"

RDEPEND="virtual/opengl
	virtual/glu
	media-libs/freeglut
	media-libs/libpng:0
	media-libs/libsdl[joystick,video]
	media-libs/openal
	dev-libs/boost
	media-libs/freealut"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-as-needed.patch \
		"${FILESDIR}"/${P}-gcc46.patch
}

src_configure() {
	econf \
		--disable-unit-tests \
		$(use_enable static-libs static)
}

src_install() {
	default
	dobin caelum/.libs/caelum
	newdoc caelum/README README.caelum
	dodoc AUTHORS ChangeLog README TODO
	prune_libtool_files
}
