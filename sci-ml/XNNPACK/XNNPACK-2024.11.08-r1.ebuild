# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake flag-o-matic

CommitId=4ea82e595b36106653175dcb04b2aa532660d0d8

DESCRIPTION="library of floating-point neural network inference operators"
HOMEPAGE="https://github.com/google/XNNPACK/"
SRC_URI="https://github.com/google/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"

S="${WORKDIR}"/${PN}-${CommitId}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+assembly jit +memopt +sparse static-libs test"

RDEPEND="
	dev-libs/cpuinfo
	dev-libs/pthreadpool
"
DEPEND="${RDEPEND}
	sci-ml/FP16
	dev-libs/FXdiv
"

BDEPEND="test? ( dev-cpp/gtest )"
RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( static-libs )"

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/933414
	# https://github.com/google/XNNPACK/issues/6806
	filter-lto

	local mycmakeargs=(
		-DXNNPACK_BUILD_BENCHMARKS=OFF
		-DXNNPACK_USE_SYSTEM_LIBS=ON
		-DXNNPACK_BUILD_TESTS=$(usex test ON OFF)
		-DXNNPACK_LIBRARY_TYPE=$(usex static-libs static shared)
		-DXNNPACK_ENABLE_ASSEMBLY=$(usex assembly ON OFF)
		-DXNNPACK_ENABLE_MEMOPT=$(usex memopt ON OFF)
		-DXNNPACK_ENABLE_SPARSE=$(usex sparse ON OFF)
		-DCMAKE_POSITION_INDEPENDENT_CODE=ON
		-DPTHREADPOOL_SOURCE_DIR=/usr
		-DCPUINFO_SOURCE_DIR=/usr
	)

	cmake_src_configure
}

src_test() {
	local CMAKE_SKIP_TESTS=(
		unary-elementwise-nc-test
		f32-f16-vcvt-test
		f16-vlrelu-test
		f16-vsqr-test
	)
	cmake_src_test
}
