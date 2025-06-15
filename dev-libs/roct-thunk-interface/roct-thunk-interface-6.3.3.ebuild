# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( 19 )
ROCM_SKIP_GLOBALS=1
inherit cmake flag-o-matic linux-info llvm-r1 rocm

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ROCm/ROCR-Runtime/"
	inherit git-r3
	S="${WORKDIR}/${P}/libhsakmt"
else
	SRC_URI="https://github.com/ROCm/ROCR-Runtime/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/ROCR-Runtime-rocm-${PV}/libhsakmt"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Radeon Open Compute Thunk Interface"
HOMEPAGE="https://github.com/ROCm/ROCR-Runtime/tree/amd-staging/libhsakmt"
CONFIG_CHECK="~HSA_AMD ~HMM_MIRROR ~ZONE_DEVICE ~DRM_AMDGPU ~DRM_AMDGPU_USERPTR"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

RDEPEND="sys-process/numactl
	x11-libs/libdrm[video_cards_amdgpu]"
DEPEND="${RDEPEND}
	test? (
		$(llvm_gen_dep 'llvm-core/llvm:${LLVM_SLOT}')
		dev-cpp/gtest
	)"

IUSE="test"
RESTRICT="!test? ( test )"

CMAKE_BUILD_TYPE=Release

PATCHES=(
	"${FILESDIR}/${PN}-6.3.0-functions.patch"
	"${FILESDIR}/${PN}-6.3.0-musl.patch"
	"${FILESDIR}/kfdtest-6.1.0-skipIPCtest.patch"
	"${FILESDIR}/kfdtest-6.2.4-fix-llvm-header.patch"
)

test_wrapper() {
	local S="$1"
	shift 1
	local CMAKE_USE_DIR="${S}"
	local BUILD_DIR="${S}_build"
	cd "${S}" || die
	$@
}

src_prepare() {
	sed -e "s/get_version ( \"1.0.0\" )/get_version ( \"${PV}\" )/" -i CMakeLists.txt || die

	# https://github.com/ROCm/ROCR-Runtime/issues/263
	sed -e "s/\${HSAKMT_TARGET} STATIC/\${HSAKMT_TARGET}/" -i CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DBUILD_SHARED_LIBS=ON
	)
	cmake_src_configure

	if use test; then
		# ODR violations (bug #956958)
		filter-lto

		export LIBHSAKMT_PATH="${BUILD_DIR}"
		local mycmakeargs=(
			-DLLVM_DIR="$(get_llvm_prefix)"
		)
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
	TESTDIR="${S}/tests/kfdtest_build/"
	cd "${TESTDIR}" || die
	PATH="${PATH}:${TESTDIR}" ./run_kfdtest.sh
}
