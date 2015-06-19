# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/jag/jag-0.3.2.ebuild,v 1.8 2015/02/22 09:20:25 tupone Exp $

EAPI=5
inherit eutils qt4-r2 games

DESCRIPTION="Arcade 2D Puzzle Game"
HOMEPAGE="http://jag.xlabsoft.com/"
SRC_URI="http://jag.xlabsoft.com/files/${P}-src.zip
	http://jag.xlabsoft.com/files/${P}-data.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="editor"

RDEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtopengl:4
	x11-libs/libXrandr
	media-libs/libsdl[sound,video]
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${P}-src

src_prepare() {
	mv "${WORKDIR}"/${P}-data/data "${WORKDIR}"/${P}-src/
	sed -i \
		-e "s:/usr/local/bin:${GAMES_BINDIR}:g" \
		-e "s:/usr/local/games:${GAMES_DATADIR}:g" \
		-e "s:LIBS += -lSDLmain:LIBS += -lSDL -lX11:" \
		Game.pro main.cpp editor/editor.pro \
		|| die "sed failed"
}

src_configure() {
	qt4-r2_src_configure
	if use editor; then
		cd editor
		eqmake4 editor.pro
	fi
}

src_compile() {
	qt4-r2_src_compile
	if use editor; then
		cd editor
		qt4-r2_src_compile
	fi
}

src_install() {
	qt4-r2_src_install
	newicon images/logo.png ${PN}.png
	make_desktop_entry jag Jag

	if use editor; then
		cd editor
		qt4-r2_src_install
		make_desktop_entry jag-editor "Jag Level editor" ${PN}
	fi

	prepgamesdirs
}
