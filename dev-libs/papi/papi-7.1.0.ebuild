# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic fortran-2 toolchain-funcs

DESCRIPTION="Performance Application Programming Interface"
HOMEPAGE="https://icl.utk.edu/papi/"
SRC_URI="https://icl.utk.edu/projects/${PN}/downloads/${P}.tar.gz"
S="${WORKDIR}/${P}/src"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	>=dev-libs/libpfm-4.13.0[static-libs]
	virtual/mpi
"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/855983
	# https://github.com/icl-utk-edu/papi/issues/218
	filter-lto

	tc-export AR

	# TODO: Could try adding
	# --with-static-user-events=no
	# --with-static-papi-events=no
	# --with-static-lib=no
	# --with-static-tools=no
	# but this requires fixing the homebrew configure logic for
	# little gain
	local myeconfargs=(
		--with-perf-events
		--with-pfm-prefix="${EPREFIX}/usr"
		--with-pfm-libdir="${EPREFIX}/usr/$(get_libdir)"
	)

	CONFIG_SHELL="${EPREFIX}/bin/bash" econf "${myeconfargs[@]}"
}

src_install() {
	default

	dodoc ../RE*

	find "${ED}" -name '*.a' -delete || die
	find "${ED}" -name '*.la' -delete || die
}
