# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

CMAKE_MAKEFILE_GENERATOR=ninja

inherit eutils cmake-utils

DESCRIPTION="SQLite Database Browser"
HOMEPAGE="http://sqlitebrowser.org"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qt4 qt5 test"

REQUIRED_USE="^^ ( qt4 qt5 )"

RDEPEND="
	dev-db/sqlite:3
	dev-java/antlr:0[cxx]
	dev-libs/qcustomplot[qt5=]
	x11-libs/qscintilla
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
	)
	qt5? (
		dev-qt/qtnetwork:5
		dev-qt/qttest:5
		dev-qt/qtwidgets:5
	)"
DEPEND="${RDEPEND}
	qt5? ( dev-qt/linguist-tools:5 )
"

PATCHES=( "${FILESDIR}"/${P}-unbundle.patch )

src_prepare() {
	# https://github.com/qingfengxia/qhexedit still bundled
	# x11-libs/qscintilla[qt4?,qt5?] still bundled
	find libs/{antlr-2.7.7,qcustomplot-source} -delete || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_use qt5)
		$(cmake-utils_use_enable test TESTING)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	doicon images/sqlitebrowser.svg
}
