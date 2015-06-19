# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/colorcode/colorcode-0.7.2.ebuild,v 1.5 2015/02/18 19:52:11 tupone Exp $

EAPI=5
inherit eutils qt4-r2 games

MY_PN=ColorCode
DESCRIPTION="A free advanced MasterMind clone"
HOMEPAGE="http://colorcode.laebisch.com/"
SRC_URI="http://${PN}.laebisch.com/download/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-qt/qtgui:4"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_PN}-${PV}

src_prepare() {
	sed -i -e '/FLAGS/d' ${PN}.pro || die
	qt4-r2_src_prepare
}

src_configure() {
	qt4-r2_src_configure
}

src_install() {
	dogamesbin ${PN}
	newicon img/cc64.png ${PN}.png
	make_desktop_entry ${PN} ${MY_PN}
	prepgamesdirs
}
