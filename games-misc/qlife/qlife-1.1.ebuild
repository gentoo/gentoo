# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils qt4-r2 games

MY_PN=${PN/ql/QL}

DESCRIPTION="Simulates the classical Game of Life invented by John Conway"
HOMEPAGE="http://open-maker.tuxfamily.org/blog/index.php?post/2009/03/28/QLife"
SRC_URI="http://open-maker.tuxfamily.org/blog/public/${PN}_linux.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-qt/qtgui:4"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_PN}/sources

src_configure() {
	eqmake4 ${MY_PN}.pro
}

src_install() {
	dogamesbin ${MY_PN}
	newicon data/egg.png ${PN}.png
	make_desktop_entry ${MY_PN} ${MY_PN}
	prepgamesdirs
}
