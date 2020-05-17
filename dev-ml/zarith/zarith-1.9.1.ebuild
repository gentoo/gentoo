# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit findlib multilib

DESCRIPTION="Arithmetic and logic operations over arbitrary-precision integers"
HOMEPAGE="https://github.com/ocaml/Zarith"
SRC_URI="https://github.com/ocaml/Zarith/archive/release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc mpir +ocamlopt"

RDEPEND="
	>=dev-lang/ocaml-4.05:=[ocamlopt?]
	!mpir? ( dev-libs/gmp:0= )
	mpir? ( sci-libs/mpir )"

DEPEND="${RDEPEND} dev-lang/perl"
DOCS=( README.md Changes )

PATCHES=(
	"${FILESDIR}"/${P}-ar.patch
)

S="${WORKDIR}/Zarith-release-${PV}"

src_configure() {
	tc-export CC AR
	./configure -host "${CHOST}" \
		-ocamllibdir /usr/$(get_libdir)/ocaml \
		-installdir "${ED}"/usr/$(get_libdir)/ocaml \
		$(usex mpir "-mpir" "-gmp") || die
}

src_compile() {
	emake -j 1 HASOCAMLOPT=$(usex ocamlopt yes no) HASDYNLINK=$(usex ocamlopt yes no) all
	use doc && emake doc
}

src_test() {
	if use ocamlopt ; then
		emake HASOCAMLOPT=$(usex ocamlopt yes no) HASDYNLINK=$(usex ocamlopt yes no) tests
	else
		ewarn "Tests require USE=ocamlopt. Skipping them."
	fi
}

src_install() {
	findlib_src_preinst
	emake HASOCAMLOPT=$(usex ocamlopt yes no) HASDYNLINK=$(usex ocamlopt yes no) install
	dosym zarith/libzarith.a /usr/$(get_libdir)/ocaml/libzarith.a
	use doc && HTML_DOCS=( html/* )
	einstalldocs
}
