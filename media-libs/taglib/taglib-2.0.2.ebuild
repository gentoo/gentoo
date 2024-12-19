# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Library for reading and editing audio meta data"
HOMEPAGE="https://taglib.org"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1 MPL-1.1"
SLOT="0/2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="doc examples test"

RESTRICT="!test? ( test )"

RDEPEND="sys-libs/zlib"
DEPEND="
	${RDEPEND}
	dev-libs/utfcpp
	test? ( dev-util/cppunit )
"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen[dot] )
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES=$(usex examples)
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_build docs
}

src_test() {
	eninja -C "${BUILD_DIR}" check
}

src_install() {
	use doc && HTML_DOCS=( "${BUILD_DIR}"/doc/html/. )
	cmake_src_install
}
