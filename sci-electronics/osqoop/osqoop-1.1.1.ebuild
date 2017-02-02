# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils toolchain-funcs

DESCRIPTION="multi-platform open source software oscilloscope based on Qt 4"
HOMEPAGE="http://gitorious.org/osqoop/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4
	virtual/libusb:0"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}-${PN}

src_prepare() {
	cmake-utils_src_prepare

	for f in $(find datasource processing -name CMakeLists.txt); do
		sed -e '/install(TARGETS/s:DESTINATION :DESTINATION '$(get_libdir)/${PN}'/:' \
			-i "${f}" || die
	done
	sed -e '/install(TARGETS/s:DESTINATION .:DESTINATION bin:' \
		-i src/CMakeLists.txt helper/CMakeLists.txt || die

	sed -e '/potentialDirs/s:/usr/share/osqoop/:'${EPREFIX}'/usr/'$(get_libdir)/${PN}'/:' \
		-i src/OscilloscopeWindow.cpp || die
}
