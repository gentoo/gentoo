# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake flag-o-matic

CommitId=fcbf55af6cf28a4627bcd1f703ab7ad843f0f3a2

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
	>=dev-libs/cpuinfo-2023.11.04
	dev-libs/pthreadpool
"
DEPEND="${RDEPEND}
	dev-libs/FP16
	dev-libs/FXdiv
"

BDEPEND="test? ( dev-cpp/gtest )"
RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( static-libs )"

src_prepare() {
	dropTest=(
		fully-connected-test
		fully-connected-nc-test
		subgraph-fp16-test
		static-reshape-test
		qd8-f16-qc8w-gemm-minmax-test
		qd8-f32-qc8w-gemm-minmax-test
		qd8-f16-qc4w-gemm-minmax-test
		qd8-f32-qc4w-gemm-minmax-test
	)
	for id in ${dropTest[@]}
	do
		sed -i \
			-e "/ADD_TEST(NAME ${id}/d" \
			CMakeLists.txt \
			|| die
	done

	cmake_src_prepare
}

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
		-DXNNPACK_ENABLE_JIT=$(usex jit ON OFF)
		-DXNNPACK_ENABLE_MEMOPT=$(usex memopt ON OFF)
		-DXNNPACK_ENABLE_SPARSE=$(usex sparse ON OFF)
		-DCMAKE_POSITION_INDEPENDENT_CODE=ON
		-DPTHREADPOOL_SOURCE_DIR=/usr
		-DCPUINFO_SOURCE_DIR=/usr
	)

	cmake_src_configure
	cd "${BUILD_DIR}"
}
