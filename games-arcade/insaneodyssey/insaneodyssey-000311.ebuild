# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="Help West Muldune escape from a futuristic mental hospital"
HOMEPAGE="http://members.fortunecity.com/rivalentertainment/iox.html"
# Upstream has download issues.
#SRC_URI="http://members.fortunecity.com/rivalentertainment/io${PV}.tar.gz"
SRC_URI="mirror://gentoo/io${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="media-libs/libsdl[sound,video]
	media-libs/sdl-mixer
	media-libs/sdl-image"
RDEPEND=${DEPEND}

S=${WORKDIR}/${PN}

src_prepare() {
	cd ${PN}

	# Modify data load code and paths to game data
	sed -e "s:/usr/share/games:${GAMES_DATADIR}:" \
		"${FILESDIR}"/${P}-datafiles.patch > "${T}"/datafiles.patch \
		|| die
		epatch "${T}"/datafiles.patch
	sed -i \
		-e "/lvl/s:^:${GAMES_DATADIR}/${PN}/:" \
		-e "s:night:${GAMES_DATADIR}/${PN}/night:" \
		levels.dat || die
	sed -i \
		-e "s:tiles.dat:${GAMES_DATADIR}/${PN}/tiles.dat:" \
		-e "s:sprites.dat:${GAMES_DATADIR}/${PN}/sprites.dat:" \
		-e "s:levels.dat:${GAMES_DATADIR}/${PN}/levels.dat:" \
		-e "s:IO_T:${GAMES_DATADIR}/${PN}/IO_T:" \
		-e "s:tiles.att:${GAMES_DATADIR}/${PN}/tiles.att:" \
		-e "s:shot:${GAMES_DATADIR}/${PN}/shot:" \
		io.cpp || die
	sed -i \
		-e 's:\[32:[100:' \
		io.h || die
}

src_install() {
	cd ${PN}
	dogamesbin ${PN}
	insinto "${GAMES_DATADIR}"/${PN}
	doins *bmp *png *dat *att *lvl *wav *mod *IT
	newicon west00r.png ${PN}.png
	make_desktop_entry ${PN} "Insane Odyssey"
	prepgamesdirs
}
