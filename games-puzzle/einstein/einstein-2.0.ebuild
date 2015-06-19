# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/einstein/einstein-2.0.ebuild,v 1.12 2015/02/18 21:33:41 tupone Exp $

EAPI=5
inherit eutils games

DESCRIPTION="A puzzle game inspired by Albert Einstein"
HOMEPAGE="https://freecode.com/projects/einsteinpuzzle"
SRC_URI="mirror://gentoo/${P}-src.tar.gz
	mirror://gentoo/${PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-libs/libsdl[sound,video]
	media-libs/sdl-mixer
	media-libs/sdl-ttf"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}*.patch
	sed -i \
		-e "/PREFIX/s:/usr/local:${GAMES_PREFIX}:" \
		-e "s:\$(PREFIX)/share/einstein:${GAMES_DATADIR}/${PN}:" \
		-e "s:\$(PREFIX)/bin:${GAMES_BINDIR}:" \
		-e "s/\(OPTIMIZE=[^#]*\)/\0 ${CXXFLAGS}/" Makefile \
		|| die
	sed -i \
		-e "s:PREFIX L\"/share/einstein:L\"${GAMES_DATADIR}/${PN}:" main.cpp \
		|| die
}

src_install() {
	dogamesbin "${PN}"
	insinto "${GAMES_DATADIR}/${PN}/res"
	doins einstein.res
	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} "Einstein Puzzle"
	prepgamesdirs
}
