# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=${PV}

inherit cmake rocm

DESCRIPTION="HIP back-end for the parallel algorithm library Thrust"
HOMEPAGE="https://github.com/ROCm/rocThrust"
SRC_URI="
	https://github.com/ROCm/rocThrust/archive/rocm-${PV}.tar.gz -> rocThrust-${PV}.tar.gz
	test? ( https://www.sqlite.org/2023/sqlite-amalgamation-3430200.zip )
"
S="${WORKDIR}/rocThrust-rocm-${PV}"

LICENSE="Apache-2.0"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="benchmark test"
REQUIRED_USE="
	benchmark? ( ${ROCM_REQUIRED_USE} )
	test? ( ${ROCM_REQUIRED_USE} )
"

RESTRICT="!test? ( test )"

RDEPEND="dev-util/hip
	sci-libs/rocPRIM:${SLOT}[${ROCM_USEDEP}]
	test? ( dev-cpp/gtest )
	benchmark? (
		dev-cpp/benchmark
		sci-libs/rocRAND:${SLOT}[${ROCM_USEDEP}]
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-build/cmake-3.22
	test? ( app-arch/unzip )
"

PATCHES=(
	"${FILESDIR}/${PN}-4.0-operator_new.patch"
	"${FILESDIR}/${PN}-6.3.0-fix-libcxx.patch"
)

src_configure() {
	rocm_use_hipcc

	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DBUILD_TEST=$(usex test ON OFF)
		-DBUILD_BENCHMARKS=$(usex benchmark ON OFF)
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
	)

	if use test; then
		mycmakeargs+=(
			-DFETCHCONTENT_SOURCE_DIR_SQLITE_LOCAL="${WORKDIR}"/sqlite-amalgamation-3430200
		)
	fi

	cmake_src_configure
}

src_test() {
	check_amdgpu
	# uses HMM to fit tests to default <512M iGPU VRAM
	ROCTHRUST_USE_HMM="1" cmake_src_test -j1
}
