# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit qmake-utils

DESCRIPTION="This program allows users to configure Qt5 settings"
HOMEPAGE="http://qt5ct.sourceforge.net/"
SRC_URI="mirror://sourceforge/qt5ct/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
RDEPEND=">=dev-qt/qtcore-5.4.2
	>=dev-qt/qtxml-5.4.2
	>=dev-qt/qtgui-5.4.2
	>=dev-qt/qtwidgets-5.4.2"
DEPEND="${RDEPEND}
	>=dev-qt/linguist-tools-5.4.2"

src_configure() {
	eqmake5 ${PN}.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
