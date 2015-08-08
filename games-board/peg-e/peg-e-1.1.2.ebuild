# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils gnome2-utils qt4-r2 games

DESCRIPTION="A peg solitaire game"
HOMEPAGE="http://gottcode.org/peg-e/"
SRC_URI="http://gottcode.org/peg-e/${P}-src.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4"
DEPEND="${RDEPEND}"

src_configure() {
	eqmake4
}

src_install() {
	dogamesbin ${PN}
	doicon -s 48 icons/hicolor/48x48/apps/${PN}.png
	domenu icons/${PN}.desktop
	dodoc CREDITS ChangeLog
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
