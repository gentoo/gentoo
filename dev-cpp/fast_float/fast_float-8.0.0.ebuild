# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Fast and exact implementation of the C++ from_chars functions for number types"
HOMEPAGE="https://github.com/fastfloat/fast_float"
SRC_URI="https://github.com/fastfloat/fast_float/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( Apache-2.0 Boost-1.0 MIT )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ppc64 ~riscv ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( dev-cpp/doctest )"

src_configure() {
	local mycmakeargs=( -DFASTFLOAT_TEST=$(usex test) )

	# Avoid passing these without USE=test to avoid cmake warning
	# "Manually-specified variables were not used by the project"
	if use test; then
		mycmakeargs+=(
			-DSYSTEM_DOCTEST=ON
			# Unconditionally calls FetchContent
			-DFASTFLOAT_SUPPLEMENTAL_TESTS=OFF
		)
		sed -i 's/-Werror//' tests/CMakeLists.txt || die
	fi

	cmake_src_configure
}
