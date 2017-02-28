# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CMAKE_MAKEFILE_GENERATOR="emake"
inherit cmake-utils

DESCRIPTION="Simple Qt4 ID3v2 tag editor"
HOMEPAGE="https://github.com/DOOMer/qtagger"
SRC_URI="https://github.com/DOOMer/qtagger/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4
	media-libs/taglib
"
RDEPEND="${DEPEND}"

src_prepare() {
	# fix doc installation path
	sed -i -e "s/doc\/${PN}/doc\/${PF}/" CMakeLists.txt || die
	sed -i -e "s/share%1doc%1qtagger/share%1doc%1${PF}/" src/mainwindow.cpp || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_NO_BUILTIN_CHRPATH:BOOL=ON
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	rm -f "${ED}"/usr/share/doc/${PF}/{ChangeLog~,LICENSE} || die
}
