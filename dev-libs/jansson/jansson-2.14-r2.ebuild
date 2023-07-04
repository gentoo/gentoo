# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C library for encoding, decoding and manipulating JSON data"
HOMEPAGE="https://www.digip.org/jansson/"
SRC_URI="https://github.com/akheron/jansson/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/4"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"
IUSE="doc static-libs"

BDEPEND="doc? ( dev-python/sphinx )"

PATCHES=(
	"${FILESDIR}/${P}-cmake-static-build.patch"
	"${FILESDIR}/${P}-test-symbols.patch"
)

src_configure() {
	local mycmakeargs=(
		-DJANSSON_BUILD_STATIC_LIBS=$(usex static-libs)
		-DJANSSON_BUILD_DOCS=$(usex doc)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	dodoc "${S}/README.rst"
	dodoc "${S}/CHANGES"
}
