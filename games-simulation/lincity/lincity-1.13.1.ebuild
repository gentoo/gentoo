# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic games

DESCRIPTION="city/country simulation game for X and Linux SVGALib"
HOMEPAGE="http://lincity.sourceforge.net/"
SRC_URI="mirror://sourceforge/lincity/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE="nls"

# dep fix (bug #82318)
RDEPEND="media-libs/libpng:0
	x11-libs/libXext
	x11-libs/libSM
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch
	append-cflags -std=gnu89 # build with gcc5 (bug #570574)
}

src_configure() {
	egamesconf \
		$(use_enable nls) \
		--with-gzip \
		--with-x
}

src_compile() {
	# build system logic is severely broken
	emake
	emake X_PROGS
}

src_install() {
	default
	dodoc Acknowledgements CHANGES README* TODO
	make_desktop_entry xlincity Lincity
	dogamesbin xlincity
	prepgamesdirs
}
