# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools fortran-2

DESCRIPTION="Performance Application Programming Interface"
HOMEPAGE="http://icl.cs.utk.edu/papi/"
SRC_URI="http://icl.cs.utk.edu/projects/${PN}/downloads/${P}.tar.gz"
S="${WORKDIR}/${PN}-$(ver_cut 1-3)/src"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-libs/libpfm
	virtual/mpi
"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--with-shlib
		--with-perf-events
		--with-pfm-prefix="${EPREFIX}/usr"
		--with-pfm-libdir="${EPREFIX}/usr/$(get_libdir)"
		--with-shared-lib=yes
		--with-static-lib=no
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	dodoc ../RE*
}
