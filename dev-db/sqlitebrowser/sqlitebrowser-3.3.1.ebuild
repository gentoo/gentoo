# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils cmake-utils

DESCRIPTION="SQLite Database Browser"
HOMEPAGE="http://sqlitebrowser.org"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-java/antlr:0[cxx]
	dev-libs/qcustomplot[-qt5(-)]
	dev-qt/qtcore:4
	dev-qt/qtgui:4"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-unbundle.patch )

src_prepare() {
	# https://github.com/qingfengxia/qhexedit still bundled
	find libs/{antlr-2.7.7,qcustomplot-source} -delete || die
	cmake-utils_src_prepare
}

src_configure() {
	# Wait for unmask
	local mycmakeargs=(
		-DUSE_QT5=OFF
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	doicon images/sqlitebrowser.svg
	domenu distri/sqlitebrowser.desktop
}
