# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
DOCS_DEPEND="media-gfx/graphviz"
ROCM_SKIP_GLOBALS=1

LLVM_COMPAT=( 23 )

inherit cmake docs flag-o-matic llvm-r2 rocm toolchain-funcs

DESCRIPTION="C++ Heterogeneous-Compute Interface for Portability"
HOMEPAGE="https://github.com/ROCm/rocm-systems/tree/develop/projects/clr"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_SUBMODULES=()
	EGIT_REPO_URI="https://github.com/ROCm/rocm-systems.git"
	S="${WORKDIR}/${P}/projects/clr"
	TEST_S="${WORKDIR}/${P}/projects/hip-tests"
	HIP_S="${WORKDIR}/${P}/projects/hip"
	SLOT="0/7.2"
else
	SRC_URI="
		https://github.com/ROCm/rocm-systems/releases/download/therock-${PV%.0}/clr.tar.gz -> rocm-clr-${PV}.tar.gz
		https://github.com/ROCm/rocm-systems/releases/download/therock-${PV%.0}/${PN}.tar.gz -> ${P}.tar.gz
		test? (
			https://github.com/ROCm/rocm-systems/releases/download/therock-${PV%.0}/hip-tests.tar.gz -> hip-tests-${PV}.tar.gz
		)
	"
	S="${WORKDIR}/clr/"
	TEST_S="${WORKDIR}/hip-tests/catch"
	HIP_S="${WORKDIR}/hip"
	KEYWORDS="~amd64"
	SLOT="0/$(ver_cut 1-2)"
fi

LICENSE="MIT"

IUSE="debug +hip opencl test video_cards_amdgpu video_cards_nvidia"

# many tests are broken; also tests run against installed version, not built one
RESTRICT="test"

REQUIRED_USE="
	|| ( hip opencl )
	^^ ( video_cards_amdgpu video_cards_nvidia )
"

DEPEND="
	video_cards_amdgpu? (
		dev-util/rocminfo:${SLOT}
		dev-libs/rocm-comgr:${SLOT}
		dev-libs/rocr-runtime:${SLOT}
	)
	video_cards_nvidia? ( dev-libs/hipother:${SLOT} )
	x11-base/xorg-proto
	virtual/opengl[X]
"
BDEPEND="
	video_cards_amdgpu? (
		dev-util/hipcc:${SLOT}
	)
	test? (
		>=dev-cpp/catch-3.8.1:0
		media-libs/freeglut
		$(llvm_gen_dep "
			dev-util/spirv-llvm-translator:\${LLVM_SLOT}
		")
	)
"
RDEPEND="${DEPEND}
	~dev-libs/rocm-core-${PV}
	opencl? (
		!dev-libs/opencl-icd-loader
		!dev-libs/rocm-opencl-runtime
		!dev-util/clinfo
		!dev-util/opencl-headers
	)
	video_cards_amdgpu? (
		dev-util/hipcc:${SLOT}
		dev-libs/rocm-device-libs:${SLOT}
		dev-libs/roct-thunk-interface:${SLOT}
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-6.3.0-no-isystem-usr-include.patch"
	"${FILESDIR}/${PN}-7.1.0-no-hipother-install.patch"
	"${FILESDIR}/${PN}-7.2.0-noinline-fixes.patch"
	"${FILESDIR}/${PN}-10.1.0-aligned-new.patch"
)

QA_FLAGS_IGNORED="usr/lib.*/libhiprtc-builtins.*"

hip_test_wrapper() {
	local CMAKE_USE_DIR="${TEST_S}"
	local BUILD_DIR="${TEST_S}_build"
	cd "${TEST_S}" || die
	"${@}"
}

src_prepare() {
	pushd "${HIP_S}" >/dev/null || die

	# hipamd is itself built by cmake, and should never provide a
	# FindHIP.cmake module. But the reality is some package relies on it.
	# Set HIP and HIP Clang paths directly, don't search using heuristics
	sed -e "s:# Search for HIP installation:set(HIP_ROOT_DIR \"${EPREFIX}/usr\"):" \
		-e "s:#Set HIP_CLANG_PATH:set(HIP_CLANG_PATH \"$(get_llvm_prefix -d)/bin\"):" \
		-i "cmake/FindHIP.cmake" || die
	popd >/dev/null || die

	sed -e "s/ -Werror//g" -i "hipamd/src/CMakeLists.txt" || die

	# do not install /usr/share/doc/${P}-asan
	sed -e "/asan COMPONENT asan/d" -i hipamd/packaging/CMakeLists.txt || die

	sed -e "s/@HIP_INSTALLS_HIPCC@/ON/g" -i hipamd/hip-config.cmake.in || die

	# skip installation of hipcc: installed via dev-util/hipcc
	sed -e "s/NOT \${HIPCC_BIN_DIR}/INSTALL_HIPCC AND NOT \${HIPCC_BIN_DIR}/" \
		-i "hipamd/CMakeLists.txt" || die

	sed -e "/cmake_minimum_required/ s/3\.[35]/3.10/" \
		-i opencl/khronos/icd/CMakeLists.txt \
		-i opencl/khronos/headers/opencl2.2/tests/CMakeLists.txt || die

	cmake_src_prepare

	if use test; then
		local PATCHES=()
		# do not rewrite CatchAddTests.cmake of system Catch2: its empty-test-list
		# bug (catchorg/Catch2#3075) is fixed in Gentoo's version, the rest is WSL-only
		# shellcheck disable=SC2016
		sed -e "s/-Wall -Wextra //" \
			-e '/^file(READ "${CATCH_ADD_TESTS_SCRIPT}"/,/^endif()/d' \
			-i "${TEST_S}/CMakeLists.txt" || die

		# with libc++: host references in the math tests use long double and C++17 special
		# functions, which are ambiguous or missing in HIP code; the g++ tests link GCC objects
		if [[ $(tc-get-cxx-stdlib) == libc++ ]]; then
			sed -e "/add_subdirectory(math)/d" -e "/add_subdirectory(g++)/d" \
				-i "${TEST_S}/unit/CMakeLists.txt" || die
		fi

		# the tests write to vectors that are only reserve()d
		sed -e "s/input\([12]\)\.reserve(size);/input\1.resize(size);/" \
			-i "${TEST_S}"/unit/library/loadlib_{co,rtc}.cc || die

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

	use debug && CMAKE_BUILD_TYPE="Debug"
	# upstream release builds have assertions disabled; some are reachable
	# (e.g. on process exit), aborting otherwise working programs
	use debug || append-cppflags -DNDEBUG

	# Fix ld.lld linker error: https://github.com/ROCm/HIP/issues/3382
	# See also: https://github.com/gentoo/gentoo/pull/29097
	append-ldflags $(test-flags-CCLD -Wl,--undefined-version)

	local mycmakeargs=(
		-DCMAKE_PREFIX_PATH="$(get_llvm_prefix)"
		# hiprtc-builtins embeds headers preprocessed by this clang.  It must
		# match the LLVM slot used by rocm-comgr, not clang from PATH.
		-Dclang="$(get_llvm_prefix)/bin/clang"
		-Dllvm-mc="$(get_llvm_prefix)/bin/llvm-mc"
		-DCMAKE_SKIP_RPATH=ON
		-D__HIP_ENABLE_PCH=OFF

		-DCLR_BUILD_HIP="$(usex hip)"
		-DCLR_BUILD_OCL="$(usex opencl)"

		-DHIP_COMMON_DIR="${HIP_S}"
		-DHIP_ENABLE_ROCPROFILER_REGISTER=OFF
		-DHIPCC_BIN_DIR="${EPREFIX}/usr/bin"
		-DROCM_PATH="${EPREFIX}/usr"

		-DCMAKE_DISABLE_FIND_PACKAGE_Git=ON
	)

	if use video_cards_amdgpu; then
		mycmakeargs+=(
			-DHIP_PLATFORM="amd"
			-DOpenGL_GL_PREFERENCE="GLVND"
			-DUSE_PROF_API=OFF
		)
	elif use video_cards_nvidia; then
		mycmakeargs+=(
			-DHIPNV_DIR="${EPREFIX}/usr"
			-DHIP_PLATFORM="nvidia"
		)
	fi

	cmake_src_configure

	if use test; then
		local mycmakeargs=(
			-DROCM_PATH="${EPREFIX}/usr"
			-DCMAKE_NO_SYSTEM_FROM_IMPORTED=ON
			-DHIP_TESTS_ENABLE_WERROR=OFF
			-Wno-dev

			# 1) Use custom build of hipamd instead of system one
			# 2) Build fails with libc++: https://github.com/llvm/llvm-project/issues/119076
			-DCMAKE_CXX_FLAGS="-I${BUILD_DIR}/hipamd/include -stdlib=libstdc++"
			-DCMAKE_EXE_LINKER_FLAGS="-L${BUILD_DIR}/hipamd/lib"
		)
		if use video_cards_amdgpu; then
			mycmakeargs+=(
				-DHIP_PLATFORM="amd"
			)
		elif use video_cards_nvidia; then
			mycmakeargs+=(
				-DHIP_PLATFORM="nvidia"
			)
		fi
		hip_test_wrapper cmake_src_configure
	fi
}

src_compile() {
	cmake_src_compile

	if use test; then
		hip_test_wrapper cmake_src_compile build_tests contract_tests
	fi
}

src_test() {
	check_amdgpu
	export LD_LIBRARY_PATH="${BUILD_DIR}/hipamd/lib"
	export ROCM_PATH="${EPREFIX}/usr"

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

		# Allocate a large share of device memory or system RAM, or 4+ GiB at once.
		# On APUs this starves other GPU clients (crashing the desktop session) or OOMs.
		Unit_hipMalloc_Allocate90PercentOfDeviceMemory
		Unit_hipMalloc_Positive_APU_LargeAllocSpill
		Unit_hipMemMap_Positive_APU_LargeAllocSpill
		Unit_hipMallocManaged_OverSubscription
		Unit_hipMemRangeGetAttribute_TstCountParam
		Unit_hipMemPoolMaxAlloc
		Unit_hipHostMalloc_AllocateMoreThanTotalSystemMemory
		Unit_hipHostAlloc_AllocateMoreThanTotalSystemMemory
		Unit_hipHostRegister_Negative
		Unit_hipGraphAddMemAllocNode_Negative_LaunchOutOfMemory
		Unit_hipArray3DCreate_MaxTexture
		Unit_hipMalloc3DArray_MaxTexture
		Unit_hipArrayCreate_maxTexture
		Unit_hipMallocArray_MaxTexture_Default
		Unit_hipFreeMipmappedArrayImplicitSyncArray

		# SPIR-V input requires ROCm/SPIRV-LLVM-Translator in rocm-comgr
		Unit_hiprtc_spirv_compilation
		Unit_hiprtc_spirv_linker
		Unit_hip_linker_spirv_input
	)

	# GL interop tests need an X display
	hip_test_wrapper cmake_src_test -j1 -LE gl_interop
}
