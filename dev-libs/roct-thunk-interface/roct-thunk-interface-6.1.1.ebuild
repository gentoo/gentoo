# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_SKIP_GLOBALS=1
inherit cmake linux-info rocm

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ROCm/ROCT-Thunk-Interface/"
	inherit git-r3
else
	SRC_URI="https://github.com/ROCm/ROCT-Thunk-Interface/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/ROCT-Thunk-Interface-rocm-${PV}"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Radeon Open Compute Thunk Interface"
HOMEPAGE="https://github.com/ROCm/ROCT-Thunk-Interface"
CONFIG_CHECK="~HSA_AMD ~HMM_MIRROR ~ZONE_DEVICE ~DRM_AMDGPU ~DRM_AMDGPU_USERPTR"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

RDEPEND="sys-process/numactl
	x11-libs/libdrm[video_cards_amdgpu]"
DEPEND="${RDEPEND}
	test? ( sys-devel/llvm
	dev-cpp/gtest )"

IUSE="test"
RESTRICT="!test? ( test )"

CMAKE_BUILD_TYPE=Release

PATCHES=(
	"${FILESDIR}/${PN}-5.7.1-musl.patch"
	"${FILESDIR}/${PN}-6.1.0-visibility.patch"
	"${FILESDIR}/kfdtest-6.1.0-linklibLLVM.patch"
	"${FILESDIR}/kfdtest-6.1.0-libpath.patch"
	"${FILESDIR}/kfdtest-6.1.0-skipIPCtest.patch"
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
	sed -e "s:get_version ( \"1.0.0\" ):get_version ( \"${PV}\" ):" -i CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCPACK_PACKAGING_INSTALL_PREFIX="${EPREFIX}/usr"
	)
	cmake_src_configure

	if use test; then
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
	TESTDIR="${S}/tests/kfdtest_build/"
	cd "${TESTDIR}" || die
	PATH="${PATH}:${TESTDIR}" ./run_kfdtest.sh
}
