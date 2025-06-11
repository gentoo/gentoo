# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Cross-platform library for building Telegram clients"
HOMEPAGE="https://github.com/tdlib/td"

MY_PV="51743dfd01dff6179e2d8f7095729caa4e2222e9"
SRC_URI="https://github.com/tdlib/td/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/td-${MY_PV}"

LICENSE="Boost-1.0"
SLOT="0/${PV%_p*}"
KEYWORDS="~amd64 ~arm64 ~loong"
IUSE="+tde2e test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/openssl
	sys-libs/zlib
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/gperf
"

src_prepare() {
	sed -e '/add_library(/s/ STATIC//' \
		-i CMakeLists.txt */CMakeLists.txt || die
	sed -e '/set(INSTALL_STATIC_TARGETS /s/ tdjson_static TdJsonStatic//' \
		-e '/generate_pkgconfig(tdjson_static /d' \
		-i CMakeLists.txt || die

	# Benchmarks take way too long to compile
	sed -e '/add_subdirectory(benchmark)/d' \
		-i CMakeLists.txt || die

	# Fix tests linking
	sed -e 's/target_link_libraries(run_all_tests PRIVATE /&tdmtproto /' \
		-i test/CMakeLists.txt

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DTDE2E_INSTALL_INCLUDES=yes
	)
	cmake_src_configure

	if use tde2e; then
		# Generate cmake configuration files for the e2e-only variant
		# These are required by certain programs which depend on "tde2e"
		mycmakeargs+=( -DTD_E2E_ONLY=ON )
		BUILD_DIR="${S}_tde2e" cmake_src_configure
	fi
}

src_install() {
	cmake_src_install

	if use tde2e; then
		# Install the tde2e headers
		insinto /usr/include/td/e2e
		doins tde2e/td/e2e/e2e_api.h tde2e/td/e2e/e2e_errors.h

		# Install the tde2e cmake files
		cd "${S}_tde2e" || die
		insinto /usr/$(get_libdir)/cmake/tde2e
		doins tde2eConfig.cmake tde2eConfigVersion.cmake
		doins CMakeFiles/Export/*/tde2eStaticTargets*.cmake
	fi
}
