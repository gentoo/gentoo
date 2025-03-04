# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_SKIP_GLOBALS=1

inherit cmake rocm

DESCRIPTION="library for accelerating mixed precision matrix multiply-accumulate operations"
HOMEPAGE="https://github.com/ROCm/rocWMMA"
SRC_URI="https://github.com/ROCm/rocWMMA/archive/rocm-${PV}.tar.gz -> rocWMMA-${PV}.tar.gz"
S="${WORKDIR}/rocWMMA-rocm-${PV}"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

DEPEND="dev-util/hip:${SLOT}"

IUSE_TARGETS=( gfx908 gfx90a gfx940 gfx941 gfx942 gfx1100 gfx1101 gfx1102 )
IUSE_TARGETS=( "${IUSE_TARGETS[@]/#/amdgpu_targets_}" )
ROCM_USEDEP_OPTFLAGS=${IUSE_TARGETS[*]/%/(-)?}
ROCM_USEDEP=${ROCM_USEDEP_OPTFLAGS// /,}
ROCM_REQUIRED_USE=" || ( ${IUSE_TARGETS[*]} )"

BDEPEND="
	test? (
		dev-cpp/gtest
		sci-libs/rocBLAS:${SLOT}[${ROCM_USEDEP}]
	)
	dev-build/rocm-cmake
"

IUSE="${IUSE_TARGETS[*]/#/+} test"

REQUIRED_USE="${ROCM_REQUIRED_USE}"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${PN}-6.1.1-no-test-install.patch
)

src_prepare() {
	# unknown arguments for hipcc
	sed -e "s/ -parallel-jobs=4//" \
		-e "s/ -Xclang -fallow-half-arguments-and-returns//" \
		-i CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	rocm_use_hipcc

	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DROCM_SYMLINK_LIBS=OFF
		-DROCWMMA_BUILD_SAMPLES=OFF
		-DROCWMMA_BUILD_TESTS="$(usex test)"
	)
	use test && mycmakeargs+=(-DROCWMMA_USE_SYSTEM_GOOGLETEST=ON)
	cmake_src_configure
}

src_test() {
	check_amdgpu

	# Expected time on gfx1100 is 1260s (-j1) or 936s (-j32)
	# Visible devices are limited to the first one to exclude APU (if not disabled in the BIOS)
	HIP_VISIBLE_DEVICES=0 cmake_src_test
}
