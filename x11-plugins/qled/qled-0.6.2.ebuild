# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit qt4-r2

MY_PN="QLed"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Custom Led widget plugin for Qt-Designer"
HOMEPAGE="http://qt-apps.org/content/show.php?content=72482"
SRC_URI="http://qt-apps.org/CONTENT/content-files/72482-${MY_P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	|| ( ( >=dev-qt/qtgui-4.8.5:4 dev-qt/designer:4 ) <dev-qt/qtgui-4.8.5:4 )
	dev-qt/qtsvg:4"
DEPEND="${RDEPEND}
	app-arch/unzip"
