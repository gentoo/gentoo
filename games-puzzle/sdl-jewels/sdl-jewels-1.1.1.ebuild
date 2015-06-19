# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/sdl-jewels/sdl-jewels-1.1.1.ebuild,v 1.5 2015/02/25 12:32:04 tupone Exp $

EAPI=5
inherit eutils games

DESCRIPTION="Swap and match 3 or more jewels in a line in order to score points"
HOMEPAGE="http://www.linuxmotors.com/gljewel/"
SRC_URI="http://www.linuxmotors.com/gljewel/downloads/SDL_jewels-${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="test"

DEPEND="media-libs/libsdl[opengl,video]
	virtual/opengl"
RDEPEND="${DEPEND}"

S=${WORKDIR}/SDL_jewels-${PV}

src_prepare() {
	epatch "${FILESDIR}/${P}-Makefile.patch"

	# fix the data dir locations as it looks to be intended to run from src dir
	sed -i -e "s|\"data\"|\"${GAMES_DATADIR}/${PN}\"|" sound.c || die
	sed -i -e "s|data/bigfont.ppm|${GAMES_DATADIR}/${PN}/bigfont.ppm|" gljewel.c || die
	ecvs_clean
}

src_install() {
	dogamesbin gljewel

	insinto "${GAMES_DATADIR}/${PN}"
	doins -r data/*

	dodoc ChangeLog README

	make_desktop_entry gljewel SDL_jewels
	prepgamesdirs
}
