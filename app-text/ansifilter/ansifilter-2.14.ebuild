# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs qmake-utils

DESCRIPTION="Handles text files containing ANSI terminal escape codes"
HOMEPAGE="http://www.andre-simon.de/"
SRC_URI="http://www.andre-simon.de/zip/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~ppc64 ~x86"
IUSE="qt5"

RDEPEND="
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	# bug 431452
	rm src/qt-gui/moc_mydialog.cpp || die
}

src_configure() {
	if use qt5 ; then
		pushd src/qt-gui > /dev/null || die
		eqmake5
		popd > /dev/null || die
	fi
}

src_compile() {
	emake -f makefile CC="$(tc-getCXX)" CXXFLAGS="${CXXFLAGS} -DNDEBUG -std=c++11"

	if use qt5 ; then
		pushd src/qt-gui > /dev/null || die
		emake
		popd > /dev/null || die
	fi
}

src_install() {
	dobin src/${PN}
	use qt5 && dobin src/qt-gui/${PN}-gui

	gunzip man/${PN}.1.gz
	doman man/${PN}.1
	einstalldocs
}
