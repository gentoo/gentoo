# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/holotz-castle/holotz-castle-1.3.14.ebuild,v 1.5 2014/07/25 14:19:05 tupone Exp $

EAPI=4
inherit eutils toolchain-funcs games

DESCRIPTION="2D platform game"
HOMEPAGE="http://www.mainreactor.net/holotzcastle/en/index_en.html"
SRC_URI="http://www.mainreactor.net/holotzcastle/download/${P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="virtual/opengl
	virtual/glu
	media-libs/sdl-mixer
	media-libs/libsdl
	media-libs/sdl-ttf
	media-libs/sdl-image"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${P}-src

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-gcc44.patch
	"${FILESDIR}"/${P}-underlink.patch
)

src_compile() {
	tc-export AR
	emake -C JLib
	emake -C src HC_BASE="${GAMES_DATADIR}"/${PN}/
}

src_install() {
	dogamesbin holotz-castle holotz-castle-editor
	insinto "${GAMES_DATADIR}"/${PN}/game
	doins -r res/*
	insinto "${GAMES_DATADIR}"/${PN}/editor
	doins -r HCedHome/res/*
	newicon res/icon/icon.bmp ${PN}.bmp
	make_desktop_entry ${PN} "Holotz's Castle" /usr/share/pixmaps/${PN}.bmp
	make_desktop_entry ${PN}-editor "Holotz's Castle - Editor" \
		/usr/share/pixmaps/${PN}.bmp
	dodoc doc/MANUAL*.txt
	doman man/*.6
	prepgamesdirs
}
