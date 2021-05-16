# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Range library for C++14/17/20, basis for C++20's std::ranges"
HOMEPAGE="https://github.com/ericniebler/range-v3"
SRC_URI="https://github.com/ericniebler/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="amd64 ~ppc64"
IUSE=""

src_prepare() {
	sed -i -e '/Werror/d' -e '/Wextra/d' -e '/Wall/d' cmake/ranges_flags.cmake || die
	sed -i -e "s@lib/cmake@"$(get_libdir)"/cmake@g" CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	mycmakeargs=(
		-DRANGE_V3_EXAMPLES=OFF
		-DRANGE_V3_HEADER_CHECKS=OFF
		-DRANGE_V3_PERF=OFF
		-DRANGE_V3_TESTS=OFF
		-DRANGES_BUILD_CALENDAR_EXAMPLE=OFF
		-DRANGES_NATIVE=OFF
		#TODO: clang support + -DRANGES_MODULES=yes
	)
	cmake_src_configure
}
