# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit findlib eutils toolchain-funcs

DESCRIPTION="Arithmetic and logic operations over arbitrary-precision integers"
HOMEPAGE="https://forge.ocamlcore.org/projects/zarith/"
SRC_URI="https://forge.ocamlcore.org/frs/download.php/1574/${P}.tgz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="doc mpir +ocamlopt"

RDEPEND="
	>=dev-lang/ocaml-4:=[ocamlopt?]
	!mpir? ( dev-libs/gmp:0= )
	mpir? ( sci-libs/mpir )"

DEPEND="${RDEPEND} dev-lang/perl"

src_configure() {
	tc-export CC
	./configure -host "${CHOST}" \
		-ocamllibdir "/usr/$(get_libdir)" \
		-installdir "${ED}/usr/$(get_libdir)/ocaml" \
		$(usex mpir "-mpir" "-gmp") || die
}

src_compile() {
	emake HASOCAMLOPT=$(usex ocamlopt yes no) HASDYNLINK=$(usex ocamlopt yes no) all
	use doc && emake doc
}

src_test() {
	emake HASOCAMLOPT=$(usex ocamlopt yes no) HASDYNLINK=$(usex ocamlopt yes no) tests
}

src_install() {
	findlib_src_preinst
	emake HASOCAMLOPT=$(usex ocamlopt yes no) HASDYNLINK=$(usex ocamlopt yes no) install
	dodoc Changes README
	use doc && dohtml html/*
}
