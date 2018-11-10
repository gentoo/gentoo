# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils multilib toolchain-funcs

DESCRIPTION="Another implementation of the double description method"
HOMEPAGE="http://www.ifor.math.ethz.ch/~fukuda/cdd_home/"
SRC_URI="ftp://ftp.ifor.math.ethz.ch/pub/fukuda/cdd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""

DEPEND="dev-libs/gmp:0="
RDEPEND="${DEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-headers.patch \
		"${FILESDIR}"/${P}-gentoo.patch \
		"${FILESDIR}"/${P}-gcc-5.patch \
		"${FILESDIR}"/${P}-qa-const-char.patch
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		GMPLIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		GMPINCLUDE="${EPREFIX}/usr/include" \
		all

}

src_install() {
	dobin cddr+ cddf+
}
