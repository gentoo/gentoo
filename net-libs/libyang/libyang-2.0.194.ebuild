# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_ECLASS=cmake
inherit cmake-multilib

DESCRIPTION="YANG data modeling language library"
HOMEPAGE="https://github.com/CESNET/libyang"
SRC_URI="https://github.com/CESNET/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/libpcre2[${MULTILIB_USEDEP}]"
DEPEND="
	${RDEPEND}
	test? ( dev-util/cmocka )
"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )
"

multilib_src_configure() {
	local mycmakeargs=(
		-DENABLE_TESTS=$(usex test)
		-DENABLE_VALGRIND_TESTS=OFF
	)
	cmake_src_configure
}

multilib_src_compile() {
	cmake_src_compile

	multilib_is_native_abi && use doc && cmake_src_compile doc
}

multilib_src_install_all() {
	use doc && dodoc -r doc/.
}
