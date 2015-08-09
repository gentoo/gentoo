# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils qmake-utils games

DESCRIPTION="Qt5-based Chess Database Utility"
HOMEPAGE="http://chessx.sourceforge.net/"
SRC_URI="http://sourceforge.net/projects/chessx/files/chessx/${PV}/${P}.tgz"

LICENSE="GPL-2+ LGPL-2+ LGPL-2.1+ ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-qt/qtprintsupport:5
	dev-qt/qtsvg:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtmultimedia:5
	dev-qt/qtxml:5
	sys-libs/zlib"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools"

src_prepare() {
	epatch "${FILESDIR}"/${P}-zlib.patch
}

src_configure() {
	eqmake5
}

src_install() {
	dogamesbin release/${PN}
	dodoc ChangeLog TODO
	doicon data/images/${PN}.png
	domenu unix/chessx.desktop
	prepgamesdirs
}
