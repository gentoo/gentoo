# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit qt4-r2

MY_PN=${PN}2
MY_P=${PN}_v${PV}

DESCRIPTION="Powerful text searches using regular expressions"
HOMEPAGE="http://searchmonkey.sourceforge.net/"
# Switch to ^s when we switch to EAPI=6.
SRC_URI="mirror://sourceforge/project/${PN}/S${MY_PN:1}/${PV}%20%5Bstable%5D/${MY_P}.zip"

LICENSE="GPL-3"
SLOT="2"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}"/${MY_P}

PATCHES=(
	"${FILESDIR}"/${P}-gcc4.7.patch
	"${FILESDIR}"/${P}-gcc6.patch
)

src_install() {
	newbin ${PN} ${MY_PN}

	# Hand-made desktop icon
	doicon pixmaps/searchmonkey-300x300.png
	domenu "${FILESDIR}"/${P}.desktop
}
