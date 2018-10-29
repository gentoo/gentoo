# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FORTRAN_STANDARD="77 90"

inherit fortran-2 toolchain-funcs

DESCRIPTION="HSL mathematical software library for IPOPT"
HOMEPAGE="http://www.hsl.rl.ac.uk/ipopt"
SRC_URI="${P}.tar.gz"

LICENSE="HSL"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	sci-libs/metis
	virtual/blas"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

RESTRICT="mirror fetch"

src_configure() {
	export LIBS="$($(tc-getPKG_CONFIG) --libs metis blas lapack)"
	default
	MAKEOPTS+=" -j1"
}
