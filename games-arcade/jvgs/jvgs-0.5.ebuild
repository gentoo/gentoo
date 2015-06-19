# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/jvgs/jvgs-0.5.ebuild,v 1.6 2015/06/02 01:39:52 mr_bones_ Exp $

EAPI=5
CMAKE_IN_SOURCE_BUILD=1
inherit cmake-utils eutils games

DESCRIPTION="An open-source platform game with a sketched and minimalistic look"
HOMEPAGE="http://jvgs.sourceforge.net/"
SRC_URI="mirror://sourceforge/jvgs/${P}-src.tar.gz"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="virtual/opengl
	dev-lang/lua:0
	sys-libs/zlib
	media-libs/libsdl[video]
	media-libs/sdl-mixer[vorbis]
	media-libs/freetype:2"
DEPEND="${RDEPEND}
	dev-lang/swig"

S=${WORKDIR}/${P}-src

src_prepare() {
	epatch "${FILESDIR}"/${P}-flags.patch
}

src_configure() {
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	exeinto "$(games_get_libdir)"
	doexe src/${PN}

	insinto "${GAMES_DATADIR}"/${PN}
	doins -r main.lua resources

	games_make_wrapper ${PN} "/$(games_get_libdir)/${PN}" \
		"${GAMES_DATADIR}/${PN}"

	newicon resources/drawing.svg ${PN}.svg
	make_desktop_entry ${PN} ${PN}

	dodoc AUTHORS README.markdown

	prepgamesdirs
}
