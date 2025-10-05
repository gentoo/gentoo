# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Bandwidth test for ROCm"
HOMEPAGE="https://github.com/ROCm/rocm_bandwidth_test"
SRC_URI="https://github.com/ROCm/${PN}/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-rocm-${PV}"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

RDEPEND="
	dev-libs/rocr-runtime:${SLOT}
	dev-util/hip:${SLOT}
	dev-libs/libfmt:=
	dev-libs/spdlog:=
	sys-process/numactl
"
DEPEND="
	${RDEPEND}
	dev-cpp/nlohmann_json
	dev-util/hipcc
	dev-libs/boost[stacktrace]
	net-misc/curl
	dev-cpp/cli11
	dev-cpp/catch
"

src_prepare() {
	# Relax version checks
	sed -e "s/ \${FMT_PKG_MINIMUM_REQUIRED_VERSION}//" -i cmake/build_utils.cmake || die
	sed -e "s/ \${SPDLOG_PKG_MINIMUM_REQUIRED_VERSION}//" -i cmake/build_utils.cmake || die
	sed -e "s/ \${CATCH2_PKG_MINIMUM_REQUIRED_VERSION}//" -i cmake/build_utils.cmake || die

	sed -e "/set(BOOST_PACKAGE_NAME/ s/boost/Boost/" -i cmake/build_utils.cmake || die
	sed -e "/set(CATCH2_PACKAGE_NAME/ s/catch2/Catch2/" -i cmake/build_utils.cmake || die
	sed -e "s/ QUIT)/)/" -i main/cmdline/CMakeLists.txt || die

	# https://github.com/ROCm/rocm_bandwidth_test/issues/131
	sed -e "/set(AMD_ROCM_STAGING_INSTALL_PATH/ s:/usr/local:${EPREFIX}/usr:" \
		-e "/set(AMD_STANDALONE_STAGING_INSTALL_LIBDIR/ s/lib/$(get_libdir)/" \
		-e "/set(AMD_STANDALONE_STAGING_INSTALL_EXPORTDIR/ s/lib/$(get_libdir)/" \
		-i CMakeLists.txt || die

	sed -e "/set(AMD_ROCM_STAGING_INSTALL_LIBDIR/ s/lib/$(get_libdir)/" \
		-e "/set(AMD_ROCM_STAGING_INSTALL_EXPORTDIR/ s/lib/$(get_libdir)/" \
		-e "s:DOCDIR}/\${CPACK_PACKAGE_NAME}:DOCDIR}/${P}:" \
		-i CMakeLists.txt || die

	sed -e "s:/usr/local/lib:${EPREFIX}/usr/$(get_libdir):" \
		-e "s:lib/\${AMD_TARGET_NAME}:$(get_libdir)/\${AMD_TARGET_NAME}:g" \
		-i cmake/build_utils.cmake || die

	sed -e "/set(AMD_STANDALONE_TARGET_INSTALL_PATH/ s:/usr/local:${EPREFIX}/usr:" \
		-e "/set(AMD_STANDALONE_TARGET_INSTALL_LIBDIR/ s/lib/$(get_libdir)/" \
		-e "/set(AMD_STANDALONE_TARGET_INSTALL_EXPORTDIR/ s/lib/$(get_libdir)/" \
		-i cmake/modules/post_build_utils.cmake.in || die

	sed -e "s:./rocm_bandwidth_test:rocm_bandwidth_test:" -i bin/rbt_run_tb || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DROCM_PATH="${EPREFIX}/usr"
		-DUSE_LOCAL_FMT_LIB=ON
		-DUSE_LOCAL_NLOHMANN_JSON=ON
		-DUSE_LOCAL_SPDLOG=ON
		-DUSE_LOCAL_BOOST=ON
		-DUSE_LOCAL_CLI11=ON
		-DUSE_LOCAL_CATCH2=ON

		-DAMD_APP_COMPILER_TRY_CLANG=OFF
		-DAMD_APP_STANDALONE_BUILD_PACKAGE=ON
		-DAMD_APP_TREAT_WARNINGS_AS_ERRORS=OFF
		-Wno-dev
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile AMD_TB_LIBRARY
	cmake_src_compile
}
