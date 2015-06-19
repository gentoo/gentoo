# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/tod/tod-0.ebuild,v 1.9 2015/02/19 09:06:07 ago Exp $

EAPI=5
inherit eutils games

DESCRIPTION="Tetanus On Drugs simulates playing a Tetris clone under the influence of hallucinogenic drugs"
HOMEPAGE="http://www.pineight.com/tod/"
SRC_URI="http://www.pineight.com/pc/win${PN}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="media-libs/allegro:0[X]"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch
	sed -i \
		-e "s:idltd\.dat:${GAMES_DATADIR}/${PN}/idltd.dat:" \
		rec.c || die
}

src_install() {
	newgamesbin tod-debug.exe tod
	insinto "${GAMES_DATADIR}"/${PN}
	doins idltd.dat
	dodoc readme.txt
	prepgamesdirs
}
