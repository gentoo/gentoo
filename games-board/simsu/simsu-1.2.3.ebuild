# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils gnome2-utils qt4-r2 games

DESCRIPTION="A basic sudoku game"
HOMEPAGE="http://gottcode.org/simsu/"
SRC_URI="http://gottcode.org/${PN}/${P}-src.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-qt/qtgui:4"
RDEPEND=${DEPEND}

src_prepare() {
	epatch "${FILESDIR}"/${P}-langs.patch

	sed -i \
		-e "s:GENTOODATADIR:${GAMES_DATADIR}/${PN}:" \
		src/locale_dialog.cpp || die
}

src_configure() {
	eqmake4
}

src_install() {
	dogamesbin ${PN}
	insinto "${GAMES_DATADIR}"/${PN}/translations
	doins translations/*qm
	dodoc ChangeLog
	doicon -s scalable icons/hicolor/scalable/apps/${PN}.svg
	domenu icons/${PN}.desktop
	prepgamesdirs
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
