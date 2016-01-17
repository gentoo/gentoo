# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit qmake-utils

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

PATCHES=(
	"${FILESDIR}/${P}-fix-parallel-build.patch"
)

src_configure() {
	eqmake4 ${PN}.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	dolib.so libqcodeedit.so*
}
