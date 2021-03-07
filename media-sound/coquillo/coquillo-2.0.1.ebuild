# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop qmake-utils

DESCRIPTION="GUI audio tagger based on Qt and taglib"
HOMEPAGE="https://www.linux-apps.com/content/show.php/Coquillo?content=141896"
SRC_URI="https://github.com/sjuvonen/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	media-libs/musicbrainz:5=
	media-libs/taglib
"
RDEPEND="${DEPEND}"

src_configure() {
	eqmake5
}

src_install() {
	dobin ${PN}
	doicon extra/${PN}.png
	domenu extra/${PN}.desktop
	einstalldocs
}
