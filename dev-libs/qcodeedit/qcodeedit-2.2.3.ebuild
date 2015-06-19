# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/qcodeedit/qcodeedit-2.2.3.ebuild,v 1.1 2013/10/22 10:06:58 jlec Exp $

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
"
DEPEND="${RDEPEND}
"

MAKEOPTS+=" -j1"

src_install() {
	qt4-r2_src_install
	dolib.so libqcodeedit.so*
}
