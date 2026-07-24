# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="${PV/_/-}"
MY_P="${PN}-${MY_PV}"
inherit cmake

DESCRIPTION="C++ Multi-format 1D/2D barcode image processing library"
HOMEPAGE="https://github.com/zxing-cpp/zxing-cpp"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${MY_PV}/${MY_P}.tar.gz
	test? (
		https://github.com/zxing-cpp/zxing-cpp/releases/download/v${MY_PV}/test_samples.tar.gz
			-> ${P}-test-samples.tar.gz
		)
"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0"
SLOT="0/4" # ZXING_SONAME in CMakeLists.txt
KEYWORDS="~amd64 ~riscv"

IUSE="test tools"
RESTRICT="!test? ( test )"

RDEPEND="
	>=media-libs/zint-2.16.0:=
"
DEPEND="${RDEPEND}
	dev-libs/stb
	test? (
		dev-cpp/gtest
		dev-libs/libfmt
		media-libs/libwebp
	)
"

PATCHES=(
	"${FILESDIR}"/zxing-cpp-3.1.0-gcc16.patch
)

src_prepare() {
	mkdir "${T}/cmake" || die

	# Generate our own WebPConfig.cmake, bug #937031
	cat <<-EOF > "${T}/cmake/WebPConfig.cmake" || die
	find_package(PkgConfig REQUIRED)

	pkg_check_modules(WebP REQUIRED IMPORTED_TARGET libwebp)
	add_library(WebP::webp ALIAS PkgConfig::WebP)
	list(APPEND _cmake_import_check_targets WebP::webp )

	set(WEBP_VERSION \${WebP_VERSION})
	set(WEBP_INCLUDE_DIRS \${WebP_INCLUDE_DIR})
	set(WEBP_LIBRARIES "\${WebP_LIBRARIES}")
	EOF

	# automagic doxygen and fetches doxygen-awesome-css
	cmake_comment_add_subdirectory docs

	if use test ; then
		ln -s "${WORKDIR}"/test/samples test/samples || die
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DZXING_DEPENDENCIES=LOCAL # force find_package as REQUIRED
		-DZXING_USE_BUNDLED_ZINT=OFF

		-DZXING_EXAMPLES=$(usex tools) # Build and install ZXingReader and ZXingWriter
		-DZXING_WRITERS=BOTH # should be kept on until revdeps are ported away from OLD

		-DZXING_BLACKBOX_TESTS=$(usex test)
		-DZXING_UNIT_TESTS=$(usex test)
	)
	use test && mycmakeargs+=( -DWebP_DIR="${T}/cmake" )
	cmake_src_configure
}
