# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR="emake"
COMMIT=0e74fe022ddbb689f7bae0460a21be303114029b
inherit cmake qmake-utils

DESCRIPTION="Simple Qt5 ID3v2 tag editor"
HOMEPAGE="https://github.com/DOOMer/qtagger"
SRC_URI="https://github.com/DOOMer/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="dev-qt/linguist-tools:5"
DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	media-libs/taglib
"
RDEPEND="${DEPEND}"

src_prepare() {
	# fix doc installation path
	sed -i -e "s/doc\/${PN}/doc\/${PF}/" CMakeLists.txt || die
	sed -i -e "s/share%1doc%1qtagger/share%1doc%1${PF}/" src/mainwindow.cpp || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_NO_BUILTIN_CHRPATH:BOOL=ON
		-DQT_LRELEASE_EXECUTABLE=$(qt5_get_bindir)/lrelease
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	rm "${ED}"/usr/share/doc/${PF}/LICENSE || die
}
