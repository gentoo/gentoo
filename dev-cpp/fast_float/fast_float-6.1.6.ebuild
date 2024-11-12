# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Fast and exact implementation of the C++ from_chars functions for number types"
HOMEPAGE="https://github.com/fastfloat/fast_float"
SRC_URI="https://github.com/fastfloat/fast_float/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( Apache-2.0 Boost-1.0 MIT )"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="test"

BDEPEND="test? ( dev-cpp/doctest )"

RESTRICT="!test? ( test )"

src_configure() {
	local mycmakeargs=( -DFASTFLOAT_TEST=$(usex test) )
	# Avoid passing these without USE=test to avoid cmake warning
	# "Manually-specified variables were not used by the project"
	use test && mycmakeargs+=(
		-DSYSTEM_DOCTEST=ON
		# Unconditionally calls FetchContent
		-DFASTFLOAT_SUPPLEMENTAL_TESTS=OFF
	)

	sed -i 's/-Werror//' tests/CMakeLists.txt || die

	cmake_src_configure
}
