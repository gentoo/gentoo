# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop qmake-utils

DESCRIPTION="Qt-based compact image viewer and browser"
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

src_configure() {
	eqmake5 src/${PN}.qt5.pro
}

src_install() {
	einstalldocs
	dobin qvv
	doicon images/qvv_icon_128x128.png
	make_desktop_entry qvv QVV qvv_icon_128x128
}
