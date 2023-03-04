# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
DOCS_DEPEND="media-gfx/graphviz"

inherit cmake docs llvm prefix

LLVM_MAX_SLOT=16

DESCRIPTION="C++ Heterogeneous-Compute Interface for Portability"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/hipamd"

if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ROCm-Developer-Tools/hipamd"
	EGIT_HIP_REPO_URI="https://github.com/ROCm-Developer-Tools/HIP"
	EGIT_OCL_REPO_URI="https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime"
	EGIT_CLR_REPO_URI="https://github.com/ROCm-Developer-Tools/ROCclr"
	EGIT_BRANCH="develop"
	S="${WORKDIR}/${P}"
else
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/ROCm-Developer-Tools/hipamd/archive/rocm-${PV}.tar.gz -> rocm-hipamd-${PV}.tar.gz
		https://github.com/ROCm-Developer-Tools/HIP/archive/rocm-${PV}.tar.gz -> rocm-hip-${PV}.tar.gz
		https://github.com/ROCm-Developer-Tools/ROCclr/archive/rocm-${PV}.tar.gz -> rocclr-${PV}.tar.gz
		https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/archive/rocm-${PV}.tar.gz -> rocm-opencl-runtime-${PV}.tar.gz"
	S="${WORKDIR}/hipamd-rocm-${PV}"
fi

HIP_S="${WORKDIR}"/HIP-rocm-${PV}
OCL_S="${WORKDIR}"/ROCm-OpenCL-Runtime-rocm-${PV}
CLR_S="${WORKDIR}"/ROCclr-rocm-${PV}

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

IUSE="debug test"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-util/rocminfo-5
	sys-devel/clang:${LLVM_MAX_SLOT}
	dev-libs/rocm-comgr:${SLOT}
	virtual/opengl
"
RDEPEND="${DEPEND}
	dev-perl/URI-Encode
	sys-devel/clang-runtime:=
	>=dev-libs/roct-thunk-interface-5"

PATCHES=(
	"${FILESDIR}/${PN}-5.0.1-hip_vector_types.patch"
	"${FILESDIR}/${PN}-5.0.2-set-build-id.patch"
	"${FILESDIR}/${PN}-5.3.3-remove-cmake-doxygen-commands.patch"
	"${FILESDIR}/${PN}-9999-disable-Werror.patch"
	"${FILESDIR}/${PN}-5.4.3-make-test-switchable.patch"
)

DOCS_DIR="${HIP_S}"/docs/doxygen-input
DOCS_CONFIG_NAME=doxy.cfg

pkg_setup() {
	# Ignore QA FLAGS check for library compiled from assembly sources
	QA_FLAGS_IGNORED="/usr/$(get_libdir)/libhiprtc-builtins.so.*"
}

src_unpack () {
	if [[ ${PV} == "9999" ]]; then
		git-r3_fetch
		git-r3_checkout
		git-r3_fetch "${EGIT_HIP_REPO_URI}"
		git-r3_checkout "${EGIT_HIP_REPO_URI}" "${HIP_S}"
		git-r3_fetch "${EGIT_OCL_REPO_URI}"
		git-r3_checkout "${EGIT_OCL_REPO_URI}" "${OCL_S}"
		git-r3_fetch "${EGIT_CLR_REPO_URI}"
		git-r3_checkout "${EGIT_CLR_REPO_URI}" "${CLR_S}"
	else
		default
	fi
}

src_prepare() {
	cmake_src_prepare

	eapply_user

	# correctly find HIP_CLANG_INCLUDE_PATH using cmake
	local LLVM_PREFIX="$(get_llvm_prefix "${LLVM_MAX_SLOT}")"
	sed -e "/set(HIP_CLANG_ROOT/s:\"\${ROCM_PATH}/llvm\":${LLVM_PREFIX}:" -i hip-config.cmake.in || die

	# correct libs and cmake install dir
	sed -e "/\${HIP_COMMON_DIR}/s:cmake DESTINATION .):cmake/ DESTINATION share/cmake/Modules):" -i CMakeLists.txt || die

	sed -e "/\.hip/d" \
		-e "/CPACK_RESOURCE_FILE_LICENSE/d" -i packaging/CMakeLists.txt || die

	pushd ${HIP_S} || die
	eapply "${FILESDIR}/${PN}-9999-rocm-path.patch"
	eapply "${FILESDIR}/${PN}-5.1.3-fno-stack-protector.patch"
	eapply "${FILESDIR}/${PN}-9999-hipcc-hip-version.patch"
	eapply "${FILESDIR}/${PN}-5.4.3-fix-test-build.patch"
	# Setting HSA_PATH to "/usr" results in setting "-isystem /usr/include"
	# which makes "stdlib.h" not found when using "#include_next" in header files;
	sed -e "/FLAGS .= \" -isystem \$HSA_PATH/d" \
		-e "/HIP.*FLAGS.*isystem.*HIP_INCLUDE_PATH/d" \
		-e "s:\$ENV{'DEVICE_LIB_PATH'}:'${EPREFIX}/usr/lib/amdgcn/bitcode':" \
		-e "s:\$ENV{'HIP_LIB_PATH'}:'${EPREFIX}/usr/$(get_libdir)':" -i bin/hipcc.pl || die

	# change --hip-device-lib-path to "/usr/lib/amdgcn/bitcode", must align with "dev-libs/rocm-device-libs"
	sed -e "s:\${AMD_DEVICE_LIBS_PREFIX}/lib:${EPREFIX}/usr/lib/amdgcn/bitcode:" \
		-i "${S}/hip-config.cmake.in" || die

	einfo "prefixing hipcc and its utils..."
	hprefixify $(grep -rl --exclude-dir=build/ --exclude="hip-config.cmake.in" "/usr" "${S}")
	hprefixify $(grep -rl --exclude-dir=build/ --exclude="hipcc.pl" "/usr" "${HIP_S}")

	mv bin/hipvars.pm "${T}"/hipvars.pm.orig
	cp "$(prefixify_ro "${FILESDIR}"/hipvars.pm)" bin/hipvars.pm || die "failed to replace hipvars.pm"
	sed -n '/^\$HIP_BASE_VERSION_.* = "/p' "${T}"/hipvars.pm.orig >> bin/hipvars.pm || die
	cat <<-EOF >> bin/hipvars.pm || die
	\$HIP_VERSION_MAJOR="\$HIP_BASE_VERSION_MAJOR";
	\$HIP_VERSION_MINOR="\$HIP_BASE_VERSION_MINOR";
	\$HIP_VERSION_PATCH="\$HIP_BASE_VERSION_PATCH";
	\$HIP_VERSION="\$HIP_BASE_VERSION_MAJOR.\$HIP_BASE_VERSION_MINOR.\$HIP_BASE_VERSION_PATCH";
	EOF
	sed	-e "s,@CLANG_PATH@,${LLVM_PREFIX}/bin," -i bin/hipvars.pm || die

	# Remove problematic test which leaks processes, see
	# https://github.com/ROCm-Developer-Tools/HIP/issues/2457
	rm tests/src/ipc/hipMultiProcIpcMem.cpp || die
}

src_configure() {
	use debug && CMAKE_BUILD_TYPE="Debug"

	# TODO: Currently a GENTOO configuration is build,
	# this is also used in the cmake configuration files
	# which will be installed to find HIP;
	# Other ROCm packages expect a "RELEASE" configuration,
	# see "hipBLAS"
	local mycmakeargs=(
		-DCMAKE_PREFIX_PATH="$(get_llvm_prefix "${LLVM_MAX_SLOT}")"
		-DCMAKE_BUILD_TYPE=${buildtype}
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DCMAKE_SKIP_RPATH=ON
		-DBUILD_HIPIFY_CLANG=OFF
		-DHIP_PLATFORM=amd
		-DHIP_COMPILER=clang
		-DROCM_PATH="${EPREFIX}/usr"
		-DUSE_PROF_API=0
		-DFILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DROCCLR_PATH=${CLR_S}
		-DHIP_COMMON_DIR=${HIP_S}
		-DAMD_OPENCL_PATH=${OCL_S}
		-DBUILD_TESTS=$(usex test ON OFF)
		-DHIP_CATCH_TEST=$(usex test ON OFF)
	)

	cmake_src_configure
}

src_compile() {
	HIP_PATH=${HIP_S} docs_compile
	cmake_src_compile
	# Compile test binaries; when linking, `-lamdhip64` is used, thus need
	# LIBRARY_PATH pointing to libamdhip64.so located at ${BUILD_DIR}/lib
	use test && LIBRARY_PATH="${BUILD_DIR}/lib" cmake_src_compile build_tests
}

# Copied from rocm.eclass. This ebuild does not need amdgpu_targets
# USE_EXPANDS, so it should not inherit rocm.eclass; it only uses the
# check_amdgpu function in src_test. Rename it to check-amdgpu to avoid
# pkgcheck warning.
check-amdgpu() {
	for device in /dev/kfd /dev/dri/render*; do
		addwrite ${device}
		if [[ ! -r ${device} || ! -w ${device} ]]; then
			eerror "Cannot read or write ${device}!"
			eerror "Make sure it is present and check the permission."
			ewarn "By default render group have access to it. Check if portage user is in render group."
			die "${device} inaccessible"
		fi
	done
}

src_test() {
	check-amdgpu
	# -j1 to avoid multi process on one GPU which causes coillision
	MAKEOPTS="-j1" LD_LIBRARY_PATH="${BUILD_DIR}/lib" cmake_src_test
}

src_install() {

	cmake_src_install

	rm "${ED}/usr/include/hip/hcc_detail" || die

	# Don't install .hipInfo and .hipVersion to bin/lib
	rm "${ED}/usr/bin/.hipVersion" || die
}
