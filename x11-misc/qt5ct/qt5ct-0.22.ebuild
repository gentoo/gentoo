# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
# Gentoo-Bug: https://bugs.gentoo.org/show_bug.cgi?id=577840

EAPI=5
inherit qt5-build

DESCRIPTION="This program allows users to configure Qt5 settings"
HOMEPAGE="http://qt5ct.sourceforge.net/"
SRC_URI="mirror://sourceforge/qt5ct/${P}.tar.bz2"
S="${WORKDIR}/${P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
DEPEND=">=dev-qt/qtcore-5.4.2
	>=dev-qt/qtxml-5.4.2
	>=dev-qt/linguist-tools-5.4.2
	>=dev-qt/qtgui-5.4.2
	>=dev-qt/qtwidgets-5.4.2"

RDEPEND=">=dev-qt/qtcore-5.4.2
	>=dev-qt/qtxml-5.4.2
	>=dev-qt/qtgui-5.4.2
	>=dev-qt/qtwidgets-5.4.2"
