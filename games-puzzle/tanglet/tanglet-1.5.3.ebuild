# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils xdg

DESCRIPTION="Single player word finding game based on Boggle"
HOMEPAGE="https://gottcode.org/tanglet/"
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
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-1.5.2-gentoo.patch )

src_configure() {
	eqmake5 tanglet.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}
