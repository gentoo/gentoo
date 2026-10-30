# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools fortran-2 toolchain-funcs flag-o-matic

MY_PV="$(ver_rs 0- -)"

DESCRIPTION="Matrix elements (integrals) evaluation over Cartesian Gaussian functions"
HOMEPAGE="https://github.com/evaleev/libint"
SRC_URI="https://github.com/evaleev/libint/archive/release-${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-release-${MY_PV}"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${P}-as-needed.patch
	"${FILESDIR}"/${P}-cflags.patch
)

src_prepare() {
	mv configure.{in,ac} || die
	default
	eautoreconf
}

src_configure() {
	append-cflags -std=gnu17
	local myeconfargs=(
		--enable-deriv
		--enable-r12
		--with-cc="$(tc-getCC)"
		--with-cxx="$(tc-getCXX)"
		--with-cc-optflags="${CFLAGS}"
		--with-cxx-optflags="${CXXFLAGS}"
	)
	econf "${myeconfargs[@]}"
}
