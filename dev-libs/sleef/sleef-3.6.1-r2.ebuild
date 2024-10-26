# Copyright 2022-2024 Gentoo Authors
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
IUSE="cpu_flags_x86_avx cpu_flags_x86_avx2 cpu_flags_x86_avx512f cpu_flags_x86_fma4 cpu_flags_x86_sse2 cpu_flags_x86_sse4_1 test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? ( >=dev-libs/mpfr-4.2 )
"

PATCHES=( "${FILESDIR}"/${P}-musl.patch )

src_configure() {
	local mycmakeargs=(
		-DSLEEF_DISABLE_FFTW=ON
		-DSLEEF_BUILD_QUAD=ON
		-DSLEEF_BUILD_TESTS=$(usex test ON OFF)
		-DSLEEF_DISABLE_AVX=$(usex cpu_flags_x86_avx OFF ON)
		-DSLEEF_DISABLE_AVX2=$(usex cpu_flags_x86_avx2 OFF ON)
		-DSLEEF_DISABLE_AVX512F=$(usex cpu_flags_x86_avx512f OFF ON)
		-DSLEEF_DISABLE_FMA4=$(usex cpu_flags_x86_fma4 OFF ON)
		-DSLEEF_DISABLE_SSE2=$(usex cpu_flags_x86_sse2 OFF ON)
		-DSLEEF_DISABLE_SSE4=$(usex cpu_flags_x86_sse4_1 OFF ON)
	)

	cmake_src_configure
}

src_test() {

	local myctestargs=(
		-E "iut(y)?purec(fma)?_scalar"
	)
	cmake_src_test
}
