# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT=74ab7236a30be17351edc5b83eb3579affd96913
inherit cmake xdg

DESCRIPTION="QScintilla-based tabbed text editor with syntax highlighting"
HOMEPAGE="http://juffed.com/en/ https://github.com/Mezomish/juffed"
SRC_URI="https://github.com/Mezomish/juffed/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

RDEPEND="
	app-i18n/enca
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsingleapplication[X]
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	x11-libs/qscintilla
"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/linguist-tools:5"

DOCS=( ChangeLog README )

src_prepare() {
	# Upstream version outdated/dysfunctional and CRLF terminated
	cp "${FILESDIR}"/FindQtSingleApplication.cmake cmake/ || die

	cmake_src_prepare

	sed -i -e '/set(CMAKE_CXX_FLAGS/d' CMakeLists.txt || die
}

src_configure() {
	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DUSE_ENCA=ON
		-DUSE_QT5=ON
		-DUSE_SYSTEM_QTSINGLEAPPLICATION=ON
		-DLIB_SUFFIX=${libdir/lib/}
		-DQSCINTILLA_NAMES="qscintilla2;libqscintilla2;qscintilla2_qt5;qscintilla2_qt5"
	)
	cmake_src_configure
}
