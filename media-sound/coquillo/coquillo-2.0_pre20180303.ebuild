# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

COMMIT=dc8f1c6751242d6c0416472fd91d972d110be67a
inherit desktop qmake-utils

DESCRIPTION="GUI audio tagger based on Qt and taglib"
HOMEPAGE="https://www.linux-apps.com/content/show.php/Coquillo?content=141896"
SRC_URI="https://github.com/sjuvonen/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

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

S="${WORKDIR}/${PN}-${COMMIT}"

PATCHES=(
	"${FILESDIR}/${P}-linking.patch"
	"${FILESDIR}/${P}-qt-5.11.patch"
)

src_configure() {
	eqmake5
}

src_install() {
	dobin ${PN}
	make_desktop_entry ${PN} Coquillo
	einstalldocs
}
