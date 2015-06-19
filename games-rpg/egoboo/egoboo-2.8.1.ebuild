# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/egoboo/egoboo-2.8.1.ebuild,v 1.7 2015/03/01 16:32:30 tupone Exp $

EAPI=5
inherit eutils games

DESCRIPTION="A 3d dungeon crawling adventure in the spirit of NetHack"
HOMEPAGE="http://egoboo.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="virtual/opengl
	virtual/glu
	media-libs/libsdl[joystick,video]
	media-libs/sdl-image
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-ttf
	net-libs/enet:0
	dev-games/physfs"

src_prepare() {
	edos2unix src/game/platform/file_linux.c \
		src/game/network.c \
		src/game/Makefile
	epatch "${FILESDIR}"/${P}-gentoo.patch
	sed -i \
		-e "s:@GENTOO_DATADIR@:${GAMES_DATADIR}/${PN}:" \
		-e "s:@GENTOO_CONFDIR@:${GAMES_SYSCONFDIR}/${PN}:" \
		src/game/platform/file_linux.c || die "sed failed"
	rm -rf src/enet || die "failed removing enet"
}

src_compile() {
	emake -C src/game PROJ_NAME=egoboo-2.x
}

src_install() {
	dodoc BUGS.txt Changelog.txt doc/*.txt doc/*.pdf

	insinto "${GAMES_DATADIR}/${PN}"
	doins -r basicdat modules
	insinto "${GAMES_SYSCONFDIR}/${PN}"
	doins -r controls.txt setup.txt

	newgamesbin src/game/egoboo-2.x ${PN}

	newicon basicdat/icon.bmp ${PN}.bmp
	make_desktop_entry ${PN} Egoboo /usr/share/pixmaps/${PN}.bmp

	prepgamesdirs
}
