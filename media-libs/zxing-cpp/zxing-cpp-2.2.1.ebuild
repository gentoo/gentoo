# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C++ Multi-format 1D/2D barcode image processing library"
HOMEPAGE="https://github.com/nu-book/zxing-cpp"
SRC_URI="https://github.com/nu-book/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/3"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES=OFF # nothing is installed
		-DBUILD_BLACKBOX_TESTS=OFF # FIXME: FetchContent.cmake module usage
		-DBUILD_UNIT_TESTS=OFF # for both tests options. no thanks. bug #793173
	)
	cmake_src_configure
}
