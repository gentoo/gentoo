# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qt4-r2

DESCRIPTION="Qt-Framework for code editing"
HOMEPAGE="http://edyuk.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/edyuk/${PN}/${PV}/${P}.zip"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-qt/qtgui:4
	dev-qt/qtcore:4
	dev-qt/qtxmlpatterns:4
	dev-qt/designer:4
"
DEPEND="${RDEPEND}
"

MAKEOPTS+=" -j1"

src_install() {
	qt4-r2_src_install
	dolib.so libqcodeedit.so*
}
