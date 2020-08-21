# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop qmake-utils

DESCRIPTION="Qt5 client for the music player daemon (MPD)"
HOMEPAGE="https://sourceforge.net/projects/quimup/"
SRC_URI="mirror://sourceforge/${PN}/${PN^}_${PV}_source.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	>=media-libs/libmpdclient-2.3
	media-libs/taglib
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${PN^}_${PV}_source"

DOCS=( changelog FAQ.txt README )

src_configure() {
	eqmake5
}

src_install() {
	default
	dobin ${PN}

	newicon src/resources/mn_icon.png ${PN}.png
	make_desktop_entry ${PN} Quimup
}
