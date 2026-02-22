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
SLOT="0/4"
KEYWORDS=""
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=media-libs/zint-2.16.0:="
DEPEND="${RDEPEND}
	test? (
		dev-cpp/gtest
		dev-libs/libfmt
		dev-libs/stb
	)
"

src_prepare() {
	if use test ; then
		ln -s "${WORKDIR}"/test/samples test/samples || die
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DZXING_DEPENDENCIES=LOCAL # force find_package as REQUIRED
		-DZXING_EXAMPLES=OFF # nothing is installed
		-DZXING_USE_BUNDLED_ZINT=OFF
		-DZXING_WRITERS=BOTH # should be kept on until revdeps are ported away from OLD
		-DZXING_BLACKBOX_TESTS=$(usex test)
		-DZXING_UNIT_TESTS=$(usex test)
	)
	cmake_src_configure
}
