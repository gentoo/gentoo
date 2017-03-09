# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils fortran-2 toolchain-funcs

DESCRIPTION="Conjugate gradient Codes for large sparse linear systems"
HOMEPAGE="http://fetk.org/codes/cgcode/index.html"
SRC_URI="http://www.fetk.org/codes/download/${P}.tar.gz"

SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-2"
IUSE=""

RDEPEND="virtual/blas"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}"/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${PV}-gentoo.patch

	cat >> make.inc <<- EOF
	F77 = $(tc-getFC)
	FFLAGS = ${FFLAGS}
	BLASLIBS = $($(tc-getPKG_CONFIG) --libs blas)
	EOF
}

src_install() {
	dobin goos good
	dolib.so src/lib${PN}.so*
	dodoc INTRODUCTION NOTE README
}
