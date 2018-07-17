# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils qmake-utils

DESCRIPTION="A color matching game"
HOMEPAGE="https://gottcode.org/hexalate/"
SRC_URI="https://gottcode.org/${PN}/${P}-src.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
"

src_configure() {
	eqmake5 PREFIX="/usr"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
