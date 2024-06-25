# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DOCS_BUILDER="doxygen"
DOCS_DEPEND="media-gfx/graphviz"

inherit cmake docs llvm prefix python-any-r1

LLVM_MAX_SLOT=15

DESCRIPTION="C++ Heterogeneous-Compute Interface for Portability"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/hipamd"
SRC_URI="https://github.com/ROCm-Developer-Tools/hipamd/archive/rocm-${PV}.tar.gz -> rocm-hipamd-${PV}.tar.gz
	https://github.com/ROCm-Developer-Tools/HIP/archive/rocm-${PV}.tar.gz -> rocm-hip-${PV}.tar.gz
	https://github.com/ROCm-Developer-Tools/ROCclr/archive/rocm-${PV}.tar.gz -> rocclr-${PV}.tar.gz
	https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/archive/rocm-${PV}.tar.gz -> rocm-opencl-runtime-${PV}.tar.gz
	profile? ( https://github.com/ROCm-Developer-Tools/roctracer/archive/refs/tags/rocm-${PV}.tar.gz -> rocm-tracer-${PV}.tar.gz
			https://github.com/ROCm-Developer-Tools/hipamd/files/8991181/hip_prof_str_diff.gz -> ${P}-update-header.patch.gz
	)"

KEYWORDS="~amd64"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

IUSE="debug profile"

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
BDEPEND="profile? ( $(python_gen_any_dep '
	dev-python/CppHeaderParser[${PYTHON_USEDEP}]
	') )
"

PATCHES=(
	"${FILESDIR}/${PN}-5.0.1-DisableTest.patch"
	"${FILESDIR}/${PN}-4.2.0-config-cmake-in.patch"
	"${FILESDIR}/${PN}-5.0.1-hip_vector_types.patch"
	"${FILESDIR}/${PN}-4.2.0-cancel-hcc-header-removal.patch"
	"${FILESDIR}/${PN}-5.0.2-set-build-id.patch"
	"${FILESDIR}/${PN}-5.1.3-fix-hip_prof_gen.patch"
	"${FILESDIR}/${PN}-5.1.3-correct-sample-install-location.patch"
	"${FILESDIR}/${PN}-5.1.3-remove-cmake-doxygen-commands.patch"
	"${FILESDIR}/${PN}-5.1.3-0001-SWDEV-316128-HIP-surface-API-support.patch"
	"${FILESDIR}/${PN}-5.1.3-llvm-15-noinline-keyword.patch"
)

python_check_deps() {
	if use profile; then
		python_has_version "dev-python/CppHeaderParser[${PYTHON_USEDEP}]"
	fi
}

S="${WORKDIR}/hipamd-rocm-${PV}"
HIP_S="${WORKDIR}"/HIP-rocm-${PV}
OCL_S="${WORKDIR}"/ROCm-OpenCL-Runtime-rocm-${PV}
CLR_S="${WORKDIR}"/ROCclr-rocm-${PV}
RTC_S="${WORKDIR}"/roctracer-rocm-${PV}
DOCS_DIR="${HIP_S}"/docs/doxygen-input
DOCS_CONFIG_NAME=doxy.cfg

src_prepare() {
	cmake_src_prepare
	use profile && eapply "${WORKDIR}/${P}-update-header.patch"

	eapply_user

	# Use Gentoo slot number, otherwise git hash is attempted in vain.
	sed -e "/set (HIP_LIB_VERSION_STRING/cset (HIP_LIB_VERSION_STRING ${SLOT#*/})" -i CMakeLists.txt || die

	# disable PCH, because it results in a build error in ROCm 4.0.0
	sed -e "s:option(__HIP_ENABLE_PCH:#option(__HIP_ENABLE_PCH:" -i CMakeLists.txt || die

	# correctly find HIP_CLANG_INCLUDE_PATH using cmake
	local LLVM_PREFIX="$(get_llvm_prefix "${LLVM_MAX_SLOT}")"
	local CLANG_RESOURCE_DIR=$("${LLVM_PREFIX}/bin/clang" -print-resource-dir)
	sed -e "/set(HIP_CLANG_ROOT/s:\"\${ROCM_PATH}/llvm\":${LLVM_PREFIX}:" -i hip-config.cmake.in || die

	# correct libs and cmake install dir
	sed -e "/LIB_INSTALL_DIR/s:PREFIX}/lib:PREFIX}/$(get_libdir):" \
		-e "/\${HIP_COMMON_DIR}/s:cmake DESTINATION .):cmake/ DESTINATION share/cmake/Modules):" -i CMakeLists.txt || die
	sed -e "/LIBRARY DESTINATION/s:lib:$(get_libdir):" -i src/CMakeLists.txt || die

	sed -e "/\.hip/d" \
		-e "s,DESTINATION lib,DESTINATION $(get_libdir),g" \
		-e "/cmake DESTINATION/d" \
		-e "/CPACK_RESOURCE_FILE_LICENSE/d" -i packaging/CMakeLists.txt || die

	pushd ${HIP_S} || die
	eapply "${FILESDIR}/${PN}-5.1.3-clang-include-path.patch"
	eapply "${FILESDIR}/${PN}-5.1.3-rocm-path.patch"
	eapply "${FILESDIR}/${PN}-5.0.2-correct-ldflag.patch"
	eapply "${FILESDIR}/${PN}-5.1.3-fno-stack-protector.patch"
	# Setting HSA_PATH to "/usr" results in setting "-isystem /usr/include"
	# which makes "stdlib.h" not found when using "#include_next" in header files;
	sed -e "/FLAGS .= \" -isystem \$HSA_PATH/d" \
		-e "/HIP.*FLAGS.*isystem.*HIP_INCLUDE_PATH/d" \
		-e "s:\$ENV{'DEVICE_LIB_PATH'}:'${EPREFIX}/usr/lib/amdgcn/bitcode':" \
		-e "s:\$ENV{'HIP_LIB_PATH'}:'${EPREFIX}/usr/$(get_libdir)':" \
		-e "/rpath/s,--rpath=[^ ]*,," \
		-e "s,\$HIP_CLANG_PATH/../lib/clang/\$HIP_CLANG_VERSION/,${CLANG_RESOURCE_DIR}/,g" \
		-i bin/hipcc.pl || die

	# change --hip-device-lib-path to "/usr/lib/amdgcn/bitcode", must align with "dev-libs/rocm-device-libs"
	sed -e "s:\${AMD_DEVICE_LIBS_PREFIX}/lib:${EPREFIX}/usr/lib/amdgcn/bitcode:" \
		-i "${S}/hip-config.cmake.in" || die

	einfo "prefixing hipcc and its utils..."
	hprefixify $(grep -rl --exclude-dir=build/ --exclude="hip-config.cmake.in" "/usr" "${S}")
	hprefixify $(grep -rl --exclude-dir=build/ --exclude="hipcc.pl" "/usr" "${HIP_S}")

	cp "$(prefixify_ro "${FILESDIR}"/hipvars-5.1.3.pm)" bin/hipvars.pm || die "failed to replace hipvars.pm"
	sed -e "s,@HIP_BASE_VERSION_MAJOR@,$(ver_cut 1)," -e "s,@HIP_BASE_VERSION_MINOR@,$(ver_cut 2)," \
		-e "s,@HIP_VERSION_PATCH@,$(ver_cut 3)," \
		-e "s,@CLANG_INCLUDE_PATH@,${CLANG_RESOURCE_DIR}/include," \
		-e "s,@CLANG_PATH@,${LLVM_PREFIX}/bin," -i bin/hipvars.pm || die

	sed -e "/HIP_CLANG_INCLUDE_SEARCH_PATHS/s,\${_IMPORT_PREFIX}.*/include,${CLANG_RESOURCE_DIR}/include," -i hip-lang-config.cmake.in || die
	popd || die
	sed -e "/HIP_CLANG_INCLUDE_SEARCH_PATHS/s,\${HIP_CLANG_ROOT}.*/include,${CLANG_RESOURCE_DIR}/include," -i hip-config.cmake.in || die

	pushd ${CLR_S} || die
	eapply "${FILESDIR}/rocclr-5.3.3-fix-include.patch"
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
		-DUSE_PROF_API=$(usex profile 1 0)
		-DROCCLR_PATH=${CLR_S}
		-DHIP_COMMON_DIR=${HIP_S}
		-DAMD_OPENCL_PATH=${OCL_S}
	)

	use profile && mycmakeargs+=( -DPROF_API_HEADER_PATH="${RTC_S}"/inc/ext )

	cmake_src_configure
}

src_compile() {
	HIP_PATH=${HIP_S} docs_compile
	cmake_src_compile
}

src_install() {

	cmake_src_install

	rm "${ED}/usr/include/hip/hcc_detail" || die

	# Don't install .hipInfo and .hipVersion to bin/lib
	rm "${ED}/usr/lib/.hipInfo" "${ED}/usr/bin/.hipVersion" || die
}
