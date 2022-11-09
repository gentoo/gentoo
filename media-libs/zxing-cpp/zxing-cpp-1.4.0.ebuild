# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C++ Multi-format 1D/2D barcode image processing library"
HOMEPAGE="https://github.com/nu-book/zxing-cpp"
SRC_URI="https://github.com/nu-book/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/1.4"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE=""

# Downstream patch until revdeps like LibreOffice are fixed
PATCHES=( "${FILESDIR}/${P}-install-required-private-headers.patch" )

src_configure() {
	local mycmakeargs=(
		-DINSTALL_PRIVATE_HEADERS=ON # required by LibreOffice as of 7.3.5.1
		-DBUILD_EXAMPLES=OFF # nothing is installed
		-DBUILD_BLACKBOX_TESTS=OFF # FIXME: FetchContent.cmake module usage
		-DBUILD_UNIT_TESTS=OFF # for both tests options. no thanks. bug #793173
	)
	cmake_src_configure
}
