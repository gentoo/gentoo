# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Tools for generating DVD files to be played on standalone DVD players"
HOMEPAGE="http://dvdauthor.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE="graphicsmagick"

RDEPEND=">=dev-libs/fribidi-0.19.2
	dev-libs/libxml2
	>=media-libs/freetype-2
	media-libs/libdvdread
	media-libs/libpng:0=
	graphicsmagick? ( media-gfx/graphicsmagick )
	!graphicsmagick? ( >=media-gfx/imagemagick-5.5.7.14 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${PN}

DOCS=( AUTHORS ChangeLog README TODO )

src_prepare() {
	epatch "${FILESDIR}/${P}-glibc220.patch"
	use graphicsmagick && \
		sed -i -e 's:ExportImagePixels:dIsAbLeAuToMaGiC&:' configure
}

src_configure() {
	use graphicsmagick && \
		append-cppflags "$($(tc-getPKG_CONFIG) --cflags GraphicsMagick)" #459976
	append-cppflags "$($(tc-getPKG_CONFIG) --cflags fribidi)" #417041
	econf
}
