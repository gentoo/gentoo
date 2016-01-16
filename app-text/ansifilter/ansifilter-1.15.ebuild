# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs qmake-utils

DESCRIPTION="Handles text files containing ANSI terminal escape codes"
HOMEPAGE="http://www.andre-simon.de/"
SRC_URI="http://www.andre-simon.de/zip/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qt5"

RDEPEND="
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)"
DEPEND="${RDEPEND}"

pkg_setup() {
	myopts=(
		"CC=$(tc-getCXX)"
		"CFLAGS=${CFLAGS} -c"
		"LDFLAGS=${LDFLAGS}"
		"DESTDIR=${ED}"
		"PREFIX=${EPREFIX}/usr"
		"doc_dir=${EPREFIX}/usr/share/doc/${PF}/"
	)
}

src_prepare() {
	# bug 431452
	rm src/qt-gui/moc_mydialog.cpp || die
}

src_compile() {
	emake -f makefile "${myopts[@]}"
	if use qt5 ; then
		cd src/qt-gui
		eqmake5
		emake
	fi
}

src_install() {
	emake -f makefile "${myopts[@]}" install
	use qt5 && emake -f makefile "${myopts[@]}" install-gui
}
