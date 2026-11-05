# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_SKIP_GLOBALS=1

inherit cmake rocm

DESCRIPTION="library for accelerating mixed precision matrix multiply-accumulate operations"
HOMEPAGE="https://github.com/ROCm/rocm-libraries/tree/develop/projects/rocwmma"
SRC_URI="https://github.com/ROCm/rocm-libraries/releases/download/therock-${PV%.0}/rocwmma.tar.gz -> rocwmma-${PV}.tar.gz"
S="${WORKDIR}/rocwmma"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

IUSE_TARGETS=(
	gfx908 gfx90a gfx942 gfx950 gfx1100 gfx1101 gfx1102 gfx1103
	gfx1150 gfx1151 gfx1152 gfx1153 gfx1200 gfx1201
)
IUSE_TARGETS=( "${IUSE_TARGETS[@]/#/amdgpu_targets_}" )
ROCM_REQUIRED_USE=" || ( ${IUSE_TARGETS[*]} )"

IUSE="${IUSE_TARGETS[*]/#/+} test"
REQUIRED_USE="test? ( ${ROCM_REQUIRED_USE} )"

RESTRICT="!test? ( test )"

DEPEND="
	dev-util/hip:${SLOT}
	llvm-runtimes/openmp
"
# interface dependencies of header library
RDEPEND="${DEPEND}"

BDEPEND="
	test? (
		>=dev-cpp/gtest-1.16.0
		sci-libs/rocBLAS:${SLOT}
	)
	dev-build/rocm-cmake
"

PATCHES=(
	"${FILESDIR}"/${P}-no-test-install.patch
	"${FILESDIR}"/${P}-llvm-23.patch
	"${FILESDIR}"/${P}-std-traits.patch
)

src_configure() {
	rocm_use_clang

	local mycmakeargs=(
		-DGPU_TARGETS="$(get_amdgpu_flags)"
		-DROCWMMA_BUILD_SAMPLES=OFF
		-DROCWMMA_BUILD_TESTS="$(usex test)"
	)
	use test && mycmakeargs+=(-DROCWMMA_USE_SYSTEM_GOOGLETEST=ON)
	cmake_src_configure
}

src_test() {
	check_amdgpu

	# hipRTC tests compile the headers at runtime
	local -x ROCWMMA_INCLUDE_PATH="${S}/library/include"
	# Expected time on gfx1100 is 1260s (-j1) or 936s (-j32)
	# Visible devices are limited to the first one to exclude APU (if not disabled in the BIOS)
	HIP_VISIBLE_DEVICES=0 cmake_src_test -j1
}
