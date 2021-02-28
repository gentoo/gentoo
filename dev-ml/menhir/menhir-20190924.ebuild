# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit findlib eutils

DESCRIPTION="LR(1) parser generator for the OCaml language"
HOMEPAGE="http://gallium.inria.fr/~fpottier/menhir/"
SRC_URI="https://gitlab.inria.fr/fpottier/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ppc ~ppc64 x86"
IUSE="examples +ocamlopt"

RDEPEND=">=dev-lang/ocaml-4.02:=[ocamlopt?]"
DEPEND="${RDEPEND}
	dev-ml/ocamlbuild"

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
	dodoc README.md CHANGES.md
}
