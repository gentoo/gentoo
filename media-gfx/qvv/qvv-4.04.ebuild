# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop qmake-utils

DESCRIPTION="QVV Image Viewer and Browser"
HOMEPAGE="http://cade.datamax.bg/qvv/"
SRC_URI="https://github.com/cade-vs/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}"

DOCS=( ANFSCD GPG_README HISTORY README todo.txt )

PATCHES=( "${FILESDIR}"/${P}-toLatin1.patch )

src_configure() {
	eqmake5 src/${PN}.qt5.pro
}

src_install() {
	einstalldocs
	dobin qvv
	doicon images/qvv_icon_128x128.png || die "doicon failed"
	make_desktop_entry qvv QVV qvv_icon_128x128
}
