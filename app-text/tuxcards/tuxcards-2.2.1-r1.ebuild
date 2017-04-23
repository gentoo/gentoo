# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils qmake-utils

DESCRIPTION="A hierarchical notebook"
HOMEPAGE="http://www.tuxcards.de/"
SRC_URI="http://www.tuxcards.de/src/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE=""

DEPEND="dev-qt/qtgui:4"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_configure() {
	eqmake4 tuxcards.pro
}

src_install() {
	dobin ${PN}
	newicon src/icons/lo32-app-tuxcards.png ${PN}.png
	make_desktop_entry ${PN} TuxCards ${PN} "Qt;Utility"
	dodoc AUTHORS README
}
