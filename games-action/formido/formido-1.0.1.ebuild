# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs games

DESCRIPTION="A shooting game in the spirit of Phobia games"
HOMEPAGE="http://www.mhgames.org/oldies/formido/"
SRC_URI="http://noe.falzon.free.fr/prog/${P}.tar.gz
	http://koti.mbnet.fi/lsoft/formido/formido-music.tar.bz2"

LICENSE="GPL-2"
SLOT=0
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="media-libs/libsdl[sound,video]
	media-libs/sdl-image
	media-libs/sdl-mixer"
RDEPEND=${DEPEND}

src_unpack() {
	unpack ${P}.tar.gz
	cd "${S}"/data
	unpack ${PN}-music.tar.bz2
}

src_prepare() {
	sed -i \
		-e "s:g++:$(tc-getCXX):" \
		-e "/^FLAGS=/s:$: ${CXXFLAGS}:" \
		-e "/^LINKFLAGS=/s:=.*:=${LDFLAGS}:" \
		-e "s:\${DATDIR}:${GAMES_DATADIR}/${PN}/data:" \
		-e "s:\${DEFCONFIGDIR}:${GAMES_DATADIR}/${PN}:" \
		Makefile || die
}

src_install() {
	dogamesbin ${PN}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r ${PN}.cfg data
	newicon data/icon.dat ${PN}.bmp
	make_desktop_entry ${PN} Formido /usr/share/pixmaps/${PN}.bmp
	dodoc README README-1.0.1
	prepgamesdirs
}
