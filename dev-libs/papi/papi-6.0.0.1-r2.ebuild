# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools fortran-2 toolchain-funcs

DESCRIPTION="Performance Application Programming Interface"
HOMEPAGE="http://icl.cs.utk.edu/papi/"
SRC_URI="http://icl.cs.utk.edu/projects/${PN}/downloads/${P}.tar.gz"
S="${WORKDIR}/${P}/src"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-libs/libpfm[static-libs]
	virtual/mpi
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-6.0.0.1-configure-clang16.patch
	"${FILESDIR}"/${PN}-6.0.0.1-configure-c99.patch
)

src_prepare() {
	default

	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
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
