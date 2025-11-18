# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_PV=${PV//./_}

DESCRIPTION="Computing automorphism groups of graphs and digraphs"
HOMEPAGE="https://pallini.di.uniroma1.it/" # (2025-11-18) no valid cert
# alternatively, use https://users.cecs.anu.edu.au/~bdm/nauty/
# HOMEPAGE="https://users.cecs.anu.edu.au/~bdm/nauty/"

SRC_URI="https://pallini.di.uniroma1.it/${PN}${MY_PV}.tar.gz"

S="${WORKDIR}/${PN}${MY_PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~riscv ~x86"
IUSE="cpu_flags_x86_popcnt threads examples"

BDEPEND="sys-apps/help2man"
DEPEND="dev-libs/gmp:0
	virtual/zlib:=
	sci-mathematics/cliquer"
RDEPEND="${DEPEND}"

DOCS=( schreier.txt formats.txt changes24-29.txt )

src_prepare() {
	default
	rm makefile libtool configure || die
	eautoreconf
}

src_configure() {
	econf --disable-static \
		--enable-tls \
		--enable-generic \
		$(use_enable cpu_flags_x86_popcnt popcnt) \
		$(use_enable threads tls)
}

src_compile() {
	default

	use threads && emake TLSlibraries
}

src_install() {
	default

	use threads && emake TLSlibraries

	if use examples; then
		docinto examples
		dodoc nautyex*.c
	fi

	find "${ED}" -name '*.la' -delete || die
}
