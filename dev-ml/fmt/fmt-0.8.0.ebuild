# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit findlib

DESCRIPTION="Combinators to devise OCaml Format pretty-printing functions"
HOMEPAGE="http://erratique.ch/software/fmt https://github.com/dbuenzli/fmt"
SRC_URI="http://erratique.ch/software/fmt/releases/${P}.tbz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-ml/result:=[ocamlopt]
	dev-lang/ocaml:=[ocamlopt]
	dev-ml/cmdliner:=[ocamlopt]"
DEPEND="${RDEPEND}
	dev-ml/opam
	dev-ml/topkg
	dev-ml/ocamlbuild
	dev-ml/findlib"

src_compile() {
	ocaml pkg/pkg.ml build || die
}

src_test() {
	ocamlbuild -use-ocamlfind test/tests.otarget || die
	./test.native || die
	./test.byte   || die
}

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		${PN}.install || die
	dodoc CHANGES.md README.md
}
