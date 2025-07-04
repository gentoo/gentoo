# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Recompress PNG files to a smaller size without loss of information"
HOMEPAGE="https://optipng.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="sys-libs/zlib
	media-libs/libpng:0="
DEPEND="${RDEPEND}"

DOCS=( AUTHORS.txt )

src_prepare() {
	rm -R third_party/{libpng,zlib} || die
	sed -i \
		-e 's/^#if defined AT_FDCWD/#if (defined(AT_FDCWD) \&\& !(defined(__SVR4) \&\& defined(__sun)))/' \
		src/optipng/ioutil.c || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DOPTIPNG_USE_SYSTEM_LIBS=ON
		-DOPTIPNG_BUILD_TESTS=$(usex test ON OFF)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	dodoc doc/* || die

	# This is https://sourceforge.net/p/optipng/bugs/93/ upstream
	fperms a+x /usr/bin/optipng
}
