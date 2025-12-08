# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=${PV}
inherit cmake rocm

DESCRIPTION="Bandwidth test for ROCm"
HOMEPAGE="https://github.com/ROCm/rocm_bandwidth_test"
SRC_URI="https://github.com/ROCm/${PN}/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-rocm-${PV}"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

REQUIRED_USE="${ROCM_REQUIRED_USE}"

RDEPEND="
	dev-libs/rocr-runtime:${SLOT}
	dev-util/hip:${SLOT}
	dev-libs/boost:=[stacktrace]
	dev-libs/libfmt:=
	dev-libs/spdlog:=
	net-misc/curl
	sys-process/numactl
"
DEPEND="
	${RDEPEND}
	dev-cpp/nlohmann_json
	dev-util/hipcc
	dev-cpp/cli11
	dev-cpp/catch
"

PATCHES=( "${FILESDIR}"/rocm_bandwidth_test-7.1.0-nogit.patch )

tb_plugin_wrapper() {
	local PATCHES=()
	local CMAKE_USE_DIR="${S}/plugins/tb/transferbench"
	local BUILD_DIR="${CMAKE_USE_DIR}/build"
	"$@"
}

src_prepare() {
	# rocm_bandwidth_test cmake files reinvents variables for everything:
	# installation paths, flags, generator, compiler, linker selection, etc.
	# Then cmake calls bash, which calls another cmake, which ignores niceness, verbose logs, CXX, etc.
	# That code is objectively bad, a lot of patches go below.
	# See also: https://github.com/ROCm/rocm_bandwidth_test/issues/131

	# Relax version checks
	sed -e "s/ \${FMT_PKG_MINIMUM_REQUIRED_VERSION}//" -i cmake/build_utils.cmake || die
	sed -e "s/ \${SPDLOG_PKG_MINIMUM_REQUIRED_VERSION}//" -i cmake/build_utils.cmake || die
	sed -e "s/ \${CATCH2_PKG_MINIMUM_REQUIRED_VERSION}//" -i cmake/build_utils.cmake || die

	sed -e "/set(BOOST_PACKAGE_NAME/ s/boost/Boost/" -i cmake/build_utils.cmake || die
	sed -e "/set(CATCH2_PACKAGE_NAME/ s/catch2/Catch2/" -i cmake/build_utils.cmake || die
	sed -e "s/ QUIT)/)/" -i main/cmdline/CMakeLists.txt || die

	sed -e "/set(AMD_ROCM_STAGING_INSTALL_PATH/ s:/usr/local:${EPREFIX}/usr:" \
		-e "/set(AMD_STANDALONE_STAGING_INSTALL_LIBDIR/ s/lib/$(get_libdir)/" \
		-e "/set(AMD_STANDALONE_STAGING_INSTALL_EXPORTDIR/ s/lib/$(get_libdir)/" \
		-i CMakeLists.txt || die

	sed -e "/set(AMD_ROCM_STAGING_INSTALL_LIBDIR/ s/lib/$(get_libdir)/" \
		-e "/set(AMD_ROCM_STAGING_INSTALL_EXPORTDIR/ s/lib/$(get_libdir)/" \
		-e "s:DOCDIR}/\${CPACK_PACKAGE_NAME}:DOCDIR}/${PF}:" \
		-i CMakeLists.txt || die

	sed -e "s:/usr/local/lib:${EPREFIX}/usr/$(get_libdir):" \
		-e "s:lib/\${AMD_TARGET_NAME}:$(get_libdir)/\${AMD_TARGET_NAME}:g" \
		-i cmake/build_utils.cmake || die

	sed -e "/set(AMD_STANDALONE_TARGET_INSTALL_PATH/ s:/usr/local:${EPREFIX}/usr:" \
		-e "/set(AMD_STANDALONE_TARGET_INSTALL_LIBDIR/ s/lib/$(get_libdir)/" \
		-e "/set(AMD_STANDALONE_TARGET_INSTALL_EXPORTDIR/ s/lib/$(get_libdir)/" \
		-i cmake/modules/post_build_utils.cmake.in || die

	sed -e "s:./rocm_bandwidth_test:rocm_bandwidth_test:" -i bin/rbt_run_tb || die

	# Let the user decide, which programs to use (definitely not `gcc -fuse-ld=lld`)
	# Bug: https://bugs.gentoo.org/965916
	sed -e '/find_program(CCACHE_PATH/d' -e '/find_program(LD_LLD_PATH/d' \
		-e '/find_program(LD_MOLD_PATH/d' -i  cmake/build_utils.cmake || die

	# Cleanup build script as we build in src_compile.
	# This shell script basically calls "cmake ... && cmake install",
	# we replace it with normal cmake.eclass functions with tb_plugin_wrapper.
	echo "" > plugins/tb/transferbench/build_libamd_tb.sh || die

	cmake_src_prepare
	tb_plugin_wrapper cmake_src_prepare
}

src_configure() {
	# Configure plugin launcher (can be compiled with any compiler)
	local mycmakeargs=(
		-DROCM_PATH="${EPREFIX}/usr"
		-DUSE_LOCAL_FMT_LIB=ON
		-DUSE_LOCAL_NLOHMANN_JSON=ON
		-DUSE_LOCAL_SPDLOG=ON
		-DUSE_LOCAL_BOOST=ON
		-DUSE_LOCAL_CLI11=ON
		-DUSE_LOCAL_CATCH2=ON

		-DAMD_APP_BUILD_DOCS=OFF
		-DAMD_APP_BUILD_EXAMPLES=OFF
		-DAMD_APP_COMPILER_TRY_CLANG=OFF
		-DAMD_APP_STANDALONE_BUILD_PACKAGE=ON
		-DAMD_APP_TREAT_WARNINGS_AS_ERRORS=OFF
		-Wno-dev
	)
	cmake_src_configure

	# Configure tb plugin (HIP code)
	rocm_use_clang
	mycmakeargs=(
		-DBUILD_INTERNAL_BINARY_VERSION=$(< VERSION)
		-DGPU_TARGETS="$(get_amdgpu_flags)"
		-DHSA_INCLUDE_DIR="${EPREFIX}/usr/include/hsa"
		-DROCM_PATH="${EPREFIX}/usr"
	)
	tb_plugin_wrapper cmake_src_configure
}

src_compile() {
	# tb plugin must be compiled before transferbench
	tb_plugin_wrapper cmake_src_compile
	cp "${S}"/plugins/tb/transferbench/build/libamd_tb.* "${S}/plugins/tb/lib" || die

	cmake_src_compile
}
