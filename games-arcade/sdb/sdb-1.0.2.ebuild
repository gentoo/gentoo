# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="a 2D top-down action game; escape a facility full of walking death machines"
HOMEPAGE="http://sdb.gamecreation.org/"
SRC_URI="http://gcsociety.sp.cs.cmu.edu/~frenzy/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="virtual/opengl
	media-libs/libsdl
	media-libs/sdl-image[png]
	media-libs/sdl-mixer"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i \
		-e "s:models/:${GAMES_DATADIR}/${PN}/models/:" \
		-e "s:snd/:${GAMES_DATADIR}/${PN}/snd/:" \
		-e "s:sprites/:${GAMES_DATADIR}/${PN}/sprites/:" \
		-e "s:levels/:${GAMES_DATADIR}/${PN}/levels/:" \
		src/sdb.h src/game.cpp || die "setting game paths"
	epatch \
		"${FILESDIR}"/${P}-endian.patch \
		"${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-ldflags.patch
}

src_compile() {
	emake \
		-C src \
		CXXFLAGS="${CXXFLAGS} $(sdl-config --cflags)"
}

src_install() {
	dogamesbin src/sdb
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r levels models snd sprites
	newicon sprites/barrel.png ${PN}.png
	make_desktop_entry sdb "Shotgun Debugger"
	dodoc ChangeLog README
	prepgamesdirs
}
