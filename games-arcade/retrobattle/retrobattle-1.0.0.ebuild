# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

MY_P="${PN}-src-${PV}"
DESCRIPTION="A NES-like platform arcade game"
HOMEPAGE="http://remar.se/andreas/retrobattle/"
SRC_URI="http://remar.se/andreas/retrobattle/files/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
# test is incomplete
RESTRICT="test"

DEPEND="media-libs/libsdl[X,sound,video]
	media-libs/sdl-mixer[wav]"
RDEPEND="${DEPEND}"
S=${WORKDIR}/${MY_P}/src

src_prepare() {
	epatch "${FILESDIR}"/${P}-{build,sound}.patch
}

src_install() {
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r "${WORKDIR}"/${MY_P}/data

	# wrapper to pass datadir location
	newgamesbin "${WORKDIR}"/${MY_P}/${PN} ${PN}.bin
	games_make_wrapper ${PN} "${PN}.bin \"${GAMES_DATADIR}/${PN}\""

	make_desktop_entry ${PN}
	dodoc "${WORKDIR}"/${MY_P}/{manual.txt,README}

	prepgamesdirs
}
