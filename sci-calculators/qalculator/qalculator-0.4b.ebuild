# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils qt4-r2

DESCRIPTION="A Qt4 based small calculator application"
HOMEPAGE="http://www.qt-apps.org/content/show.php/Qalculator?content=101326"
SRC_URI="http://www.qt-apps.org/CONTENT/content-files/101326-${P}-src.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtgui:4"

S=${WORKDIR}/${P}-src

src_install() {
	dobin Qalculator
	make_desktop_entry Qalculator Qalculator accessories-calculator
}
