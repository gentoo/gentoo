# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/btanks/btanks-0.9.8083.ebuild,v 1.10 2015/06/01 22:11:30 mr_bones_ Exp $

EAPI=5
inherit eutils scons-utils games

DESCRIPTION="Fast 2D tank arcade game with multiplayer and split-screen modes"
HOMEPAGE="http://btanks.sourceforge.net/"
SRC_URI="mirror://sourceforge/btanks/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-lang/lua-5.1:0
	media-libs/libsdl[joystick,video]
	media-libs/libvorbis
	virtual/opengl
	dev-libs/expat
	media-libs/smpeg
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-gfx"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	rm -rf sdlx/gfx
	epatch "${FILESDIR}"/${P}-scons-blows.patch \
		"${FILESDIR}"/${P}-gcc46.patch \
		"${FILESDIR}"/${P}-gcc47.patch
}

src_compile() {
	escons \
		prefix="${GAMES_PREFIX}" \
		lib_dir="$(games_get_libdir)"/${PN} \
		plugins_dir="$(games_get_libdir)"/${PN} \
		resources_dir="${GAMES_DATADIR}"/${PN}
}

src_install() {
	dogamesbin build/release/engine/btanks
	newgamesbin build/release/editor/bted btanksed
	exeinto "$(games_get_libdir)"/${PN}
	doexe build/release/*/*.so
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r data
	newicon engine/src/bt.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Battle Tanks"
	dodoc ChangeLog *.txt
	prepgamesdirs
}
