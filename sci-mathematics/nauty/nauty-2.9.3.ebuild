# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit autotools

MY_PV=${PV//./_}

DESCRIPTION="Computing automorphism groups of graphs and digraphs"
HOMEPAGE="https://pallini.di.uniroma1.it/
	https://users.cecs.anu.edu.au/~bdm/nauty/"
SRC_URI="https://users.cecs.anu.edu.au/~bdm/nauty/${PN}${MY_PV}.tar.gz
	https://dev.gentoo.org/~mjo/distfiles/${P}-unbundle-cliquer.patch.gz"

S="${WORKDIR}/${PN}${MY_PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~riscv ~x86"
IUSE="cpu_flags_x86_popcnt doc examples threads"

BDEPEND="sys-apps/help2man"
DEPEND="dev-libs/gmp:0
	virtual/zlib:=
	sci-mathematics/cliquer"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/nauty-2.9.3-extern-gt_numorbits.patch"
	"${FILESDIR}/nauty-2.9.3-malloc-calloc.patch"
	"${WORKDIR}/nauty-2.9.3-unbundle-cliquer.patch"
	"${FILESDIR}/nauty-2.9.3-zlib-dimacs2g.patch"
)

DOCS=( schreier.txt formats.txt changes24-29.txt )

# Intended when checking for [noreturn] attribute name
QA_CONFIG_IMPL_DECL_SKIP=( f )

src_prepare() {
	default
	rm makefile libtool configure || die
	eautoreconf
}

src_configure() {
	econf --enable-generic \
		$(use_enable cpu_flags_x86_popcnt popcnt) \
		$(use_enable threads tls)
}

src_compile() {
	default
	use threads && emake TLSlibs
}

src_install() {
	default
	use threads && emake DESTDIR="${D}" TLSinstall
	use doc && newdoc nug29.pdf manual.pdf

	if use examples; then
		docinto examples
		dodoc nautyex*.c
	fi

	find "${ED}" -name '*.la' -delete || die
}
