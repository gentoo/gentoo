# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit qt4-r2

DESCRIPTION="A punch clock program designed to easily keep track of your hours"
HOMEPAGE="http://gottcode.org/kapow/"
SRC_URI="http://gottcode.org/${PN}/${P}-src.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtgui:4"
RDEPEND="${DEPEND}"

src_configure() {
	eqmake4 kapow.pro PREFIX=/usr
}

DOCS="ChangeLog README"
