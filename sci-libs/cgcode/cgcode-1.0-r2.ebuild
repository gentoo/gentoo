# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fortran-2 flag-o-matic toolchain-funcs

DESCRIPTION="Conjugate gradient Codes for large sparse linear systems"
HOMEPAGE="http://fetk.org/codes/cgcode/index.html"
SRC_URI="http://www.fetk.org/codes/download/${P}.tar.gz"
S="${WORKDIR}"/${PN}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="virtual/blas"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PV}-gentoo.patch
)

src_prepare() {
	default

	# bug #862681
	append-flags -fno-strict-aliasing
	filter-lto

	# GCC 10 workaround
	# bug #722000
	append-fflags $(test-flags-FC -fallow-argument-mismatch)

	cat >> make.inc <<- EOF || die
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
