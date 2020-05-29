# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="Qt C++ widget for plotting and data visualization"
HOMEPAGE="https://www.qcustomplot.com/"
SRC_URI="
	https://www.qcustomplot.com/release/${PV}/QCustomPlot-sharedlib.tar.gz -> ${PN}-sharedlib-${PV}.tar.gz
	https://www.qcustomplot.com/release/${PV}/QCustomPlot-source.tar.gz -> ${PN}-source-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}-source

src_prepare() {
	default

	sed \
		-e 's:../../::g' \
		-e '/CONFIG/s:shared.*:shared:g' \
		"${WORKDIR}"/${PN}-sharedlib/sharedlib-compilation/sharedlib-compilation.pro > ${PN}.pro || die
}

src_configure() {
	eqmake5
}

src_install() {
	dolib.so lib${PN}*
	doheader ${PN}.h
	dodoc changelog.txt
}
