# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C++ Multi-format 1D/2D barcode image processing library"
HOMEPAGE="https://github.com/zxing-cpp/zxing-cpp"
SRC_URI="
	https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? (
		https://github.com/zxing-cpp/zxing-cpp/releases/download/v${PV}/test_samples.tar.gz
			-> ${P}-test-samples.tar.gz
		)
"

LICENSE="Apache-2.0"
SLOT="0/3"
KEYWORDS="~amd64 ~arm arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="experimental test"
RESTRICT="!test? ( test )"

RDEPEND="
	experimental? (
		media-libs/zint:=
	)
"
DEPEND="
	${RDEPEND}
	test? (
		dev-cpp/gtest
		dev-libs/libfmt
		dev-libs/stb
	)
"

PATCHES=(
	"${FILESDIR}"/zxing-cpp-2.3.0-reverse-NDEBUG.patch
)

src_prepare() {
	if use test ; then
		ln -s "${WORKDIR}"/test/samples "${S}"/test/samples || die
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DZXING_USE_BUNDLED_ZINT=OFF
		-DZXING_EXAMPLES=OFF # nothing is installed
		-DZXING_BLACKBOX_TESTS=$(usex test)
		-DZXING_UNIT_TESTS=$(usex test)
		-DZXING_DEPENDENCIES=LOCAL # force find_package as REQUIRED
		# https://github.com/zxing-cpp/zxing-cpp/blob/v2.3.0/README.md#supported-formats
		-DZXING_WRITERS=$(usex experimental BOTH OLD)
		-DZXING_EXPERIMENTAL_API=$(usex experimental)
	)
	cmake_src_configure
}
