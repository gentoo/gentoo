# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
DOCS_DEPEND="media-gfx/graphviz"
ROCM_SKIP_GLOBALS=1

inherit cmake docs flag-o-matic llvm rocm

LLVM_MAX_SLOT=17

TEST_PV=5.7.0 # No hip-test-5.7.1 release

DESCRIPTION="C++ Heterogeneous-Compute Interface for Portability"
HOMEPAGE="https://github.com/ROCm/hipamd"
SRC_URI="https://github.com/ROCm/clr/archive/refs/tags/rocm-${PV}.tar.gz -> rocm-clr-${PV}.tar.gz
	https://github.com/ROCm/HIP/archive/refs/tags/rocm-${PV}.tar.gz -> hip-${PV}.tar.gz
	test? ( https://github.com/ROCm/hip-tests/archive/refs/tags/rocm-${TEST_PV}.tar.gz )"

KEYWORDS="~amd64"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

RESTRICT="!test? ( test )"
IUSE="debug test"

DEPEND="
	>=dev-util/rocminfo-5
	sys-devel/clang:${LLVM_MAX_SLOT}
	dev-libs/rocm-comgr:${SLOT}
	>=dev-libs/rocr-runtime-5.6
	x11-base/xorg-proto
	virtual/opengl
"
BDEPEND="test? ( =dev-util/hipcc-5* )"
RDEPEND="${DEPEND}
	=dev-util/hipcc-5*
	dev-perl/URI-Encode
	sys-devel/clang-runtime:=
	>=dev-libs/roct-thunk-interface-5"

PATCHES=(
	"${FILESDIR}/${PN}-5.7.0-install.patch"
	"${FILESDIR}/${PN}-5.7.1-fix-unaligned-access.patch"
	"${FILESDIR}/${PN}-5.7.1-exec-stack.patch"
	"${FILESDIR}/${PN}-5.7.1-disable-stack-protector.patch"
	"${FILESDIR}/${PN}-5.7.1-no_asan_doc.patch"
	"${FILESDIR}/${PN}-5.7.1-extend-isa-compatibility-check.patch"
	"${FILESDIR}/${PN}-5.7.1-fix-mmap-oom-check.patch"
)

S="${WORKDIR}/clr-rocm-${PV}/"
TEST_S="${WORKDIR}/hip-tests-rocm-${TEST_PV}/catch"

hip_test_wrapper() {
	local CMAKE_USE_DIR="${TEST_S}"
	local BUILD_DIR="${TEST_S}_build"
	cd "${TEST_S}" || die
	$@
}

src_prepare() {
	# Set HIP and HIP Clang paths directly, don't search using heuristics
	sed -e "s:# Search for HIP installation:set(HIP_ROOT_DIR \"${EPREFIX}/usr\"):" \
		-e "s:#Set HIP_CLANG_PATH:set(HIP_CLANG_PATH \"$(get_llvm_prefix -d ${LLVM_MAX_SLOT})/bin\"):" \
	    -i "${WORKDIR}"/HIP-rocm-${PV}/cmake/FindHIP.cmake || die

	# https://github.com/ROCm/HIP/commit/405d029422ba8bb6be5a233d5eebedd2ad2e8bd3
	# https://github.com/ROCm/clr/commit/ab6d34ae773f4d151e04170c0f4e46c1135ddf3e
	# Migrated to hip-test, but somehow the change is not applied to the tarball.
	rm -rf "${WORKDIR}"/HIP-rocm-${PV}/tests || die
	sed -e '/tests.*cmake/d' -i hipamd/CMakeLists.txt || die

	cmake_src_prepare

	if use test; then
		local PATCHES=(
			"${FILESDIR}"/hip-test-5.7.0-rocm_agent_enumerator-location.patch \
			"${FILESDIR}"/hip-test-5.7.1-remove-incompatible-flag.patch
		)
		hip_test_wrapper cmake_src_prepare
	fi
}

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/858383
	# https://github.com/ROCm/clr/issues/64
	#
	# Do not trust it for LTO either
	append-flags -fno-strict-aliasing
	filter-lto

	# Workaround for bug #923986
	append-ldflags $(test-flags-CCLD -Wl,--undefined-version)

	use debug && CMAKE_BUILD_TYPE="Debug"

	local mycmakeargs=(
		-DCMAKE_PREFIX_PATH="$(get_llvm_prefix "${LLVM_MAX_SLOT}")"
		-DCMAKE_BUILD_TYPE=${buildtype}
		-DCMAKE_SKIP_RPATH=ON
		-DBUILD_HIPIFY_CLANG=OFF
		-DHIP_PLATFORM=amd
		-DHIP_COMMON_DIR="${WORKDIR}/HIP-rocm-${PV}"
		-DROCM_PATH="${EPREFIX}/usr"
		-DUSE_PROF_API=0
		-DFILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DCLR_BUILD_HIP=ON
		-DHIPCC_BIN_DIR="${EPREFIX}/usr/bin"
		-DOpenGL_GL_PREFERENCE="GLVND"
	)

	cmake_src_configure

	if use test; then
		local mycmakeargs=(
			-DROCM_PATH="${BUILD_DIR}"/hipamd
			-DHIP_PLATFORM=amd
			-DCMAKE_MODULE_PATH="${TEST_S}/external/Catch2/cmake/Catch2"
		)
		hip_test_wrapper cmake_src_configure
	fi
}

src_compile() {
	cmake_src_compile

	if use test; then
		HIP_PATH="${BUILD_DIR}"/hipamd \
			hip_test_wrapper cmake_src_compile build_tests
	fi
}

src_test() {
	check_amdgpu
	export LD_LIBRARY_PATH="${BUILD_DIR}/hipamd/lib"

	# TODO: research how to test Vulkan-related features.
	local CMAKE_SKIP_TESTS=(
		Unit_hipExternalMemoryGetMappedBuffer_Vulkan_Positive_Read_Write
		Unit_hipExternalMemoryGetMappedBuffer_Vulkan_Negative_Parameters
		Unit_hipImportExternalMemory_Vulkan_Negative_Parameters
		Unit_hipWaitExternalSemaphoresAsync_Vulkan_Positive_Binary_Semaphore
		Unit_hipWaitExternalSemaphoresAsync_Vulkan_Positive_Multiple_Semaphores
		Unit_hipWaitExternalSemaphoresAsync_Vulkan_Negative_Parameters
		Unit_hipSignalExternalSemaphoresAsync_Vulkan_Positive_Binary_Semaphore
		Unit_hipSignalExternalSemaphoresAsync_Vulkan_Positive_Multiple_Semaphores
		Unit_hipSignalExternalSemaphoresAsync_Vulkan_Negative_Parameters
		Unit_hipImportExternalSemaphore_Vulkan_Negative_Parameters
		Unit_hipDestroyExternalSemaphore_Vulkan_Negative_Parameters
	)

	MAKEOPTS="-j1" hip_test_wrapper cmake_src_test
}

src_install() {
	cmake_src_install

	# add version file that is required by some libraries
	mkdir "${ED}"/usr/include/rocm-core || die
	cat <<EOF > "${ED}"/usr/include/rocm-core/rocm_version.h || die
#pragma once
#define ROCM_VERSION_MAJOR $(ver_cut 1)
#define ROCM_VERSION_MINOR $(ver_cut 2)
#define ROCM_VERSION_PATCH $(ver_cut 3)
#define ROCM_BUILD_INFO "$(ver_cut 1-3).0-9999-unknown"
EOF
	dosym -r /usr/include/rocm-core/rocm_version.h /usr/include/rocm_version.h

	rm "${ED}/usr/include/hip/hcc_detail" || die

	# files already installed by hipcc, which is a runtime dep
	rm "${ED}/usr/bin/hipconfig.pl" || die
	rm "${ED}/usr/bin/hipcc.pl" || die
	rm "${ED}/usr/bin/hipcc" || die
	rm "${ED}/usr/bin/hipconfig" || die
	rm "${ED}/usr/bin/hipvars.pm" || die
}
