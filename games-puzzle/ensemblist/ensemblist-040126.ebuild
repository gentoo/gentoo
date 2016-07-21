# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="Put together several primitives to build a given shape. (C.S.G. Game)"
HOMEPAGE="http://www.nongnu.org/ensemblist/index_en.html"
SRC_URI="https://savannah.nongnu.org/download/ensemblist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc x86"
IUSE=""

DEPEND="media-libs/freeglut
	media-libs/libmikmod:0
	media-libs/libpng:0
	virtual/glu
	virtual/opengl
	x11-libs/libXmu"
RDEPEND=${DEPEND}

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch
}

src_compile() {
	emake DATADIR="\"${GAMES_DATADIR}\"/${PN}/datas" \
		CFLAGSLD="${LDFLAGS}"
}

src_install() {
	dogamesbin ensemblist
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r datas
	dodoc Changelog README
	make_desktop_entry ${PN} Ensemblist
	prepgamesdirs
}
