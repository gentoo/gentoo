# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils games

DESCRIPTION="Brain teasers, puzzle and memory games for kid's in one pack"
HOMEPAGE="http://www.viewizard.com/memonix/"
SRC_URI="http://www.viewizard.com/download/${PN}_${PV}_src.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-libs/libsdl:0[sound,opengl,video,X]
	media-libs/sdl-image[jpeg]
	media-libs/sdl-mixer[vorbis]
	!games-kids/memonix-bin"
RDEPEND="${DEPEND}"

S=${WORKDIR}/MemonixSourceCode

src_configure() {
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	exeinto "$(games_get_libdir)"
	doexe ../${P}_build/Memonix

	insinto "${GAMES_DATADIR}/${PN}"
	doins ../gamedata.vfs

	games_make_wrapper ${PN} "$(games_get_libdir)"/Memonix "${GAMES_DATADIR}"/${PN}

	newicon ../icon48.png ${PN}.png
	make_desktop_entry ${PN}

	dodoc ReadMe.txt

	prepgamesdirs
}
