# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="Simple Qt4 ID3v2 tag editor"
HOMEPAGE="https://code.google.com/p/qtagger"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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

	rm "${D}"/usr/share/doc/${PF}/{ChangeLog~,LICENSE}
}
