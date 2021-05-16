# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop qmake-utils xdg-utils

DESCRIPTION="Basic sudoku game"
HOMEPAGE="https://gottcode.org/simsu/"
SRC_URI="https://gottcode.org/${PN}/${P}-src.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

BDEPEND="
	dev-qt/linguist-tools:5
"
RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
"
DEPEND="${RDEPEND}"

src_configure() {
	eqmake5
}

src_install() {
	dobin ${PN}
	insinto /usr/share/${PN}/translations
	doins translations/*qm
	dodoc ChangeLog
	doicon -s scalable icons/hicolor/scalable/apps/${PN}.svg
	domenu icons/${PN}.desktop
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
