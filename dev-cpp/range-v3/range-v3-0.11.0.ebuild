# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Range library for C++14/17/20, basis for C++20's std::ranges"
HOMEPAGE="https://github.com/ericniebler/range-v3"
SRC_URI="https://github.com/ericniebler/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="amd64 ~ppc64"
IUSE="test"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/0.11.0-no-werror.patch"
	"${FILESDIR}/0.11.0-gcc10.patch"
)

src_prepare() {
	# header-only libraries go to arch-independent dirs
	sed -i -e 's@lib/cmake@share/cmake@g' CMakeLists.txt || die
	rm include/module.modulemap || die # https://bugs.gentoo.org/755740
	cmake_src_prepare
}

src_configure() {
	mycmakeargs=(
		-DRANGES_BUILD_CALENDAR_EXAMPLE=OFF
		-DRANGES_NATIVE=OFF
		-DRANGES_DEBUG_INFO=OFF
		-DRANGES_NATIVE=OFF
		-DRANGES_ENABLE_WERROR=OFF
		-DRANGES_VERBOSE_BUILD=ON
		-DRANGE_V3_EXAMPLES=OFF
		-DRANGE_V3_PERF=OFF
		-DRANGE_V3_DOCS=OFF
		-DRANGE_V3_HEADER_CHECKS="$(usex test ON OFF)"
		-DRANGE_V3_TESTS=$(usex test ON OFF)
		#TODO: clang support + -DRANGES_MODULES=yes
	)
	cmake_src_configure
}
