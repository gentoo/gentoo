# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit findlib

DESCRIPTION="LR(1) parser generator for the OCaml language"
HOMEPAGE="http://gallium.inria.fr/~fpottier/menhir/"
SRC_URI="http://gallium.inria.fr/~fpottier/menhir/${P}.tar.gz"

LICENSE="QPL-1.0 LGPL-2-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="examples +ocamlopt"

DEPEND=">=dev-lang/ocaml-3.09:=[ocamlopt?]"
RDEPEND="${DEPEND}"

src_configure() {
	if ! use ocamlopt ; then
		export TARGET=byte
	fi
}

src_compile() {
	emake PREFIX="${EPREFIX}"/usr -j1
}

src_install() {
	findlib_src_preinst
	emake PREFIX="${ED}"/usr docdir="${ED}"/usr/share/doc/"${PF}" $(use examples || echo "DOCS=manual.pdf") install
	use examples && docompress -x /usr/share/doc/${PF}/demos
	dodoc AUTHORS CHANGES
}
