# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Encode/decode WOFF2 font format"
HOMEPAGE="https://github.com/google/woff2"
SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"
IUSE=""

RDEPEND="app-arch/brotli:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON # needed, causes QA warnings otherwise
		-DCANONICAL_PREFIXES=ON #661942
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	dobin "${BUILD_DIR}"/woff2_compress
	dobin "${BUILD_DIR}"/woff2_decompress
	dobin "${BUILD_DIR}"/woff2_info

	einstalldocs
}
