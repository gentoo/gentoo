# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="C++ Multi-format 1D/2D barcode image processing library"
HOMEPAGE="https://github.com/nu-book/zxing-cpp"
SRC_URI="https://github.com/nu-book/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 x86"
IUSE="test"

RESTRICT="!test? ( test )"

PATCHES=( "${FILESDIR}/${P}-gcc11.patch" )

src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES=OFF # nothing is installed
		-DBUILD_BLACKBOX_TESTS=$(usex test)
	)
	cmake_src_configure
}
