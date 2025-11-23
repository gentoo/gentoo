# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Another implementation of the double description method"
HOMEPAGE="http://www.ifor.math.ethz.ch/~fukuda/cdd_home/"
SRC_URI="ftp://ftp.ifor.math.ethz.ch/pub/fukuda/cdd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86"

DEPEND="dev-libs/gmp:0="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-headers.patch
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-gcc-5.patch
	"${FILESDIR}"/${P}-qa-const-char.patch
	"${FILESDIR}"/${P}-gcc11-dynamic-exceptions.patch
)

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		GMPLIBDIR="${ESYSROOT}/usr/$(get_libdir)" \
		GMPINCLUDE="${ESYSROOT}/usr/include" \
		all
}

src_install() {
	dobin cddr+ cddf+
}
