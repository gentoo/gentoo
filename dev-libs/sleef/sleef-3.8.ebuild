# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Implements vectorized versions of C standard math functions"
HOMEPAGE="https://sleef.org/"
SRC_URI="https://github.com/shibatch/${PN}/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? ( >=dev-libs/mpfr-4.2 )
"

PATCHES=( "${FILESDIR}"/${PN}-3.6.1-musl.patch )

src_configure() {
	local mycmakeargs=(
		-DSLEEF_DISABLE_FFTW=ON
		-DSLEEF_BUILD_QUAD=ON
		-DSLEEF_BUILD_TESTS=$(usex test ON OFF)
	)

	cmake_src_configure
}

src_test() {

	local myctestargs=(
		-E "iut(y)?purec(fma)?_scalar"
	)
	cmake_src_test
}
