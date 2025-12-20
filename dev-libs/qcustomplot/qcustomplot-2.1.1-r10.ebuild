# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

DESCRIPTION="Qt C++ widget for plotting and data visualization"
HOMEPAGE="https://www.qcustomplot.com/"
SRC_URI="
	https://www.qcustomplot.com/release/${PV}/QCustomPlot-sharedlib.tar.gz -> ${PN}-sharedlib-${PV}.tar.gz
	https://www.qcustomplot.com/release/${PV}/QCustomPlot-source.tar.gz -> ${PN}-source-${PV}.tar.gz"
S=${WORKDIR}/${PN}-source

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""

RDEPEND="dev-qt/qtbase:6[gui,widgets]"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}-qmake.patch" )

src_prepare() {
	cp -a ../${PN}-sharedlib/sharedlib-compilation/sharedlib-compilation.pro ${PN}.pro || die
	default
}

src_configure() {
	eqmake6
}

src_install() {
	dolib.so lib${PN}*
	doheader ${PN}.h
	dodoc changelog.txt
}
