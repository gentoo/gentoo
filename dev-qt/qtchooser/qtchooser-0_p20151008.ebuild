# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qmake-utils toolchain-funcs

DESCRIPTION="Qt4/Qt5 version chooser"
HOMEPAGE="https://code.qt.io/cgit/qt/qtchooser.git/"
SRC_URI="https://dev.gentoo.org/~pesa/distfiles/${P}.tar.xz"

LICENSE="|| ( LGPL-2.1 GPL-3 )"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="test"

DEPEND="test? (
		dev-qt/qtcore:5
		dev-qt/qttest:5
	)"
RDEPEND="
	!<dev-qt/assistant-4.8.6:4
	!<dev-qt/designer-4.8.6:4
	!<dev-qt/linguist-4.8.6:4
	!<dev-qt/pixeltool-4.8.6:4
	!<dev-qt/qdbusviewer-4.8.6:4
	!<dev-qt/qt3support-4.8.6:4
	!<dev-qt/qtbearer-4.8.6:4
	!<dev-qt/qtcore-4.8.6:4
	!<dev-qt/qtdbus-4.8.6:4
	!<dev-qt/qtdeclarative-4.8.6:4
	!<dev-qt/qtdemo-4.8.6:4
	!<dev-qt/qtgui-4.8.6:4
	!<dev-qt/qthelp-4.8.6:4
	!<dev-qt/qtmultimedia-4.8.6:4
	!<dev-qt/qtopengl-4.8.6:4
	!<dev-qt/qtopenvg-4.8.6:4
	!<dev-qt/qtphonon-4.8.6:4
	!<dev-qt/qtscript-4.8.6:4
	!<dev-qt/qtsql-4.8.6:4
	!<dev-qt/qtsvg-4.8.6:4
	!<dev-qt/qttest-4.8.6:4
	!<dev-qt/qtwebkit-4.8.6:4
	!<dev-qt/qtxmlpatterns-4.8.6:4
"

qtchooser_make() {
	emake \
		CXX="$(tc-getCXX)" \
		LFLAGS="${LDFLAGS}" \
		prefix="${EPREFIX}/usr" \
		"$@"
}

src_compile() {
	qtchooser_make
}

src_test() {
	pushd tests/auto >/dev/null || die
	eqmake5
	popd >/dev/null || die

	qtchooser_make check
}

src_install() {
	qtchooser_make INSTALL_ROOT="${D}" install

	keepdir /etc/xdg/qtchooser

	# TODO: bash and zsh completion
	# newbashcomp scripts/${PN}.bash ${PN}
}
