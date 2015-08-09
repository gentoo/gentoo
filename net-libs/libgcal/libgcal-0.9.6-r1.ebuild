# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="C/C++ interface to the Google Data API"
HOMEPAGE="http://code.google.com/p/libgcal/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc test"

# Some tests fail
RESTRICT="test"

RDEPEND="
	dev-libs/libxml2:2
	>=net-misc/curl-7.18.2
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? ( dev-libs/check )
"

DOCS=( README )

src_configure() {
	mycmakeargs=(
		-DENABLE_TESTS=OFF
		$(cmake-utils_use debug CURL_DEBUG)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	use doc && cmake-utils_src_compile docs
}

src_install() {
	use doc && HTML_DOCS=( "${BUILD_DIR}/docs/doxygen/html/" )
	cmake-utils_src_install
}

src_test() {
	mycmakeargs+=(-DENABLE_TESTS=ON)
	cmake-utils_src_configure
	cmake-utils_src_make test
}
