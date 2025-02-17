# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C++ Multi-format 1D/2D barcode image processing library"
HOMEPAGE="https://github.com/zxing-cpp/zxing-cpp"
SRC_URI="
	https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://github.com/zxing-cpp/zxing-cpp/releases/download/v${PV}/test_samples.tar.gz -> ${P}-test-samples.tar.gz )
"

LICENSE="Apache-2.0"
SLOT="0/3"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		dev-cpp/gtest
		dev-libs/stb
	)
"

PATCHES=(
	"${FILESDIR}/${P}-cmake.patch"
	"${FILESDIR}/${P}-cxx20.patch" # bug 939897
)

src_prepare() {
	if use test ; then
		ln -s "${WORKDIR}"/test/samples "${S}"/test/samples || die
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES=OFF # nothing is installed
		-DBUILD_BLACKBOX_TESTS=$(usex test)
		-DBUILD_UNIT_TESTS=$(usex test)
	)
	cmake_src_configure
}
