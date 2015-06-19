# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/tetzle/tetzle-2.0.3.ebuild,v 1.3 2014/10/10 10:59:54 ago Exp $

EAPI=5
inherit qt4-r2 gnome2-utils games

DESCRIPTION="A jigsaw puzzle game that uses tetrominoes for the pieces"
HOMEPAGE="http://gottcode.org/tetzle/"
SRC_URI="http://gottcode.org/${PN}/${P}-src.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=dev-qt/qtgui-4.7:4
	>=dev-qt/qtopengl-4.7:4"
RDEPEND="${DEPEND}"

DOCS="ChangeLog CREDITS"

src_prepare() {
	sed -i \
		-e "s:appdir + \"/../share/\":\"${GAMES_DATADIR}/\":" \
		src/locale_dialog.cpp || die
	sed -i \
		-e "/qm.path/s:\$\$PREFIX/share:${GAMES_DATADIR}:" \
		${PN}.pro || die
}

src_configure() {
	eqmake4 BINDIR="${GAMES_BINDIR/\/usr}" PREFIX="/usr"
}

src_install() {
	qt4-r2_src_install
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
