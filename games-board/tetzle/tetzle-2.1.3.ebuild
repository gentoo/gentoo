# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils xdg

DESCRIPTION="Jigsaw puzzle game that uses tetrominoes for the pieces"
HOMEPAGE="https://gottcode.org/tetzle/"
SRC_URI="https://gottcode.org/${PN}/${P}-src.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

BDEPEND="
	dev-qt/linguist-tools:5
"
DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_configure() {
	eqmake5
}

src_install() {
	emake DESTDIR="${D}" INSTALL_ROOT="${ED}" install
	einstalldocs
}
