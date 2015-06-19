# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/dbmodel/dbmodel-0.3.ebuild,v 1.5 2013/03/02 19:49:31 hwoarang Exp $

EAPI="2"

inherit qt4-r2

DESCRIPTION="Qt4 tool for drawing entity-relational diagrams"
HOMEPAGE="http://oxygene.sk/lukas/dbmodel/"
SRC_URI="http://launchpad.net/dbmodel/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="dev-qt/qtgui:4
	dev-qt/qtsvg:4"
RDEPEND="${DEPEND}"

DOCS="AUTHORS CHANGES"

src_configure() {
	eqmake4 ${PN}.pro PREFIX=/usr
}
