# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils games

DESCRIPTION="A falling block game similar to Blockout"
HOMEPAGE="http://packages.gentoo.org/package/games-puzzle/shaaft"
SRC_URI="mirror://sourceforge/criticalmass/${P/s/S}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="virtual/opengl
	sys-libs/zlib
	media-libs/libpng:0
	media-libs/libsdl[sound,opengl,video]
	media-libs/sdl-mixer[mod]
	media-libs/sdl-image[png]"
RDEPEND=${DEPEND}

S=${WORKDIR}/${P/s/S}

src_prepare() {
	sed -i \
		-e 's:DATA_DIR:"'${GAMES_DATADIR}'\/'${PN/s/S}\/'":g' \
		game/main.cpp || die

	sed -i \
		-e 's:png12:png:g' \
		-e '/^CFLAGS=""/d' \
		-e '/^CXXFLAGS=""/d' \
		configure.in || die

	epatch \
		"${FILESDIR}"/${P}-gcc34.patch \
		"${FILESDIR}"/${P}-gcc41.patch \
		"${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-libpng15.patch
	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	egamesconf --disable-optimize
}

src_install() {
	DOCS="TODO.txt" default
	rm -f "${D}/${GAMES_BINDIR}"/Packer
	prepgamesdirs
}
