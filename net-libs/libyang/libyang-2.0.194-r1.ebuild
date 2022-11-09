# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="YANG data modeling language library"
HOMEPAGE="https://github.com/CESNET/libyang"
SRC_URI="https://github.com/CESNET/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/libpcre2"
DEPEND="
	${RDEPEND}
	test? ( dev-util/cmocka )
"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )
"

src_configure() {
	local mycmakeargs=(
		-DENABLE_TESTS=$(usex test)
		-DENABLE_VALGRIND_TESTS=OFF
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	use doc && cmake_src_compile doc
}

src_install() {
	cmake_src_install

	use doc && dodoc -r doc/.
}
