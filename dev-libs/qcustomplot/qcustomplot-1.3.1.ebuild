# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qmake-utils

DESCRIPTION="Qt C++ widget for plotting and data visualization"
HOMEPAGE="http://www.qcustomplot.com/"
SRC_URI="
	http://www.qcustomplot.com/release/${PV}/QCustomPlot-sharedlib.tar.gz -> ${PN}-sharedlib-${PV}.tar.gz
	http://www.qcustomplot.com/release/${PV}/QCustomPlot-source.tar.gz -> ${PN}-source-${PV}.tar.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="qt5"

RDEPEND="
	!qt5? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtprintsupport:5
		dev-qt/qtwidgets:5
	)
"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}-source

src_prepare() {
	sed \
		-e 's:../../::g' \
		-e '/CONFIG/s:shared.*:shared:g' \
		"${WORKDIR}"/${PN}-sharedlib/sharedlib-compilation/sharedlib-compilation.pro > ${PN}.pro || die
}

src_configure() {
	use qt5 && eqmake5 || eqmake4
}

src_install() {
	dolib.so lib${PN}*
	doheader ${PN}.h
	dodoc changelog.txt
}
