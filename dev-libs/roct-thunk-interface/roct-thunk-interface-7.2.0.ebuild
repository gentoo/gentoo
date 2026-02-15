# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( 22 )
ROCM_SKIP_GLOBALS=1
inherit cmake flag-o-matic linux-info llvm-r2 rocm

if [[ ${PV} == *9999 ]] ; then
	EGIT_SUBMODULES=()
	EGIT_REPO_URI="https://github.com/ROCm/rocm-systems.git"
	inherit git-r3
	S="${WORKDIR}/${P}/projects/rocr-runtime/libhsakmt"
else
	SRC_URI="https://github.com/ROCm/rocm-systems/releases/download/rocm-${PV}/rocr-runtime.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/rocr-runtime/libhsakmt"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Radeon Open Compute Thunk Interface"
HOMEPAGE="https://github.com/ROCm/rocm-systems/tree/develop/projects/rocr-runtime/libhsakmt"
CONFIG_CHECK="~HSA_AMD ~HMM_MIRROR ~ZONE_DEVICE ~DRM_AMDGPU ~DRM_AMDGPU_USERPTR"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

RDEPEND="
	sys-process/numactl
	x11-libs/libdrm[video_cards_amdgpu]
"
DEPEND="${RDEPEND}
	test? (
		$(llvm_gen_dep "llvm-core/llvm:\${LLVM_SLOT}")
		dev-cpp/gtest
	)"

IUSE="test"
RESTRICT="!test? ( test )"

CMAKE_BUILD_TYPE=Release

PATCHES=(
	"${FILESDIR}/${PN}-7.1.0-functions.patch"
	"${FILESDIR}/kfdtest-6.1.0-skipIPCtest.patch"
	"${FILESDIR}/kfdtest-6.2.4-fix-llvm-header.patch"
)

test_wrapper() {
	local S="$1"
	shift 1
	local CMAKE_USE_DIR="${S}"
	local BUILD_DIR="${S}_build"
	cd "${S}" || die
	"$@"
}

src_prepare() {
	sed -e "s/get_version ( \"1.0.0\" )/get_version ( \"${PV}\" )/" -i CMakeLists.txt || die

	# https://github.com/ROCm/ROCR-Runtime/issues/263
	sed -e "s/\${HSAKMT_TARGET} STATIC/\${HSAKMT_TARGET}/" -i CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	llvm_prepend_path "${LLVM_SLOT}"

	# QA warnings
	append-cxxflags -Wno-unused-value

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DBUILD_SHARED_LIBS=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_NUMA=ON # skip warning - will use find_library anyways
	)
	cmake_src_configure

	if use test; then
		# ODR violations (bug #956958)
		filter-lto

		export LIBHSAKMT_PATH="${BUILD_DIR}"
		test_wrapper "${S}/tests/kfdtest" cmake_src_configure
	fi
}

src_compile() {
	cmake_src_compile
	if use test; then
		LIBRARY_PATH="${BUILD_DIR}" test_wrapper "${S}/tests/kfdtest" cmake_src_compile
	fi
}

src_test() {
	check_amdgpu
	cd "${S}/tests/kfdtest_build/" || die
	# Bug: https://github.com/ROCm/rocm-systems/issues/3635
	local skipped_tests=(
		KFDMemoryTest.LargestSysBufferTest   # OOMs with gfx1151
		KFDMemoryTest.LargestVramBufferTest  # OOMs with gfx1151
		KFDMemoryTest.BigSysBufferStressTest # OOMs with gfx1151
		KFDQMTest.mGPUShareBO                # wants at least two GPUs?
		KFDPCSamplingTest.*                  # gfx1151: no pc sampling?
		KFDQMTest.QueueLatency               # gfx1151: fails (issues with iGPU clock?)
	)
	local IFS=:
	./run_kfdtest.sh -e "${skipped_tests[*]}" || die
}
