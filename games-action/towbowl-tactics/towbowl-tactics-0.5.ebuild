# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils games

DESCRIPTION="Tow Bowl Tactics is a game based on Games Workshop's Blood Bowl"
HOMEPAGE="http://www.towbowltactics.com/index_en.html"
SRC_URI="http://www.towbowltactics.com/download/tbt.${PV}.src.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="dev-libs/libxml2
	media-libs/smpeg
	media-libs/libsdl[sound,video]
	media-libs/sdl-net
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/tbt/src

src_prepare() {
	cd  ..
	edos2unix $(find src -type f) config.xml
	epatch "${FILESDIR}"/${P}-gentoo.patch
	sed -i \
	    -e "/^TBTHOME/ s:/.*:${GAMES_DATADIR}/tbt:" \
		src/Makefile || die
	sed -i \
		-e "/tbt.ico/ s:\"\./:TBTHOME \"/:" \
		src/Main.cpp || die
	sed -i \
		-e "s:TBTHOME \"/config.xml:\"${GAMES_SYSCONFDIR}/tbt/config.xml:g" \
		src/global.h || die
}

src_install() {
	dogamesbin tbt
	dodir "${GAMES_DATADIR}/tbt"
	cp -r ../data ../tbt.ico "${D}${GAMES_DATADIR}/tbt" || die
	insinto "${GAMES_SYSCONFDIR}/tbt"
	doins ../config.xml
	newicon ../data/images/panel/turn.png ${PN}.png
	make_desktop_entry tbt "Tow Bowl Tactics"
	prepgamesdirs
}
