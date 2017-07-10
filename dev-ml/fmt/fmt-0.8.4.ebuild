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
IUSE="test"

RDEPEND="dev-ml/result:=[ocamlopt]
	dev-lang/ocaml:=[ocamlopt]
	dev-ml/uchar:=[ocamlopt]
	dev-ml/cmdliner:=[ocamlopt]"
DEPEND="${RDEPEND}
	dev-ml/opam
	>=dev-ml/topkg-0.9
	dev-ml/ocamlbuild
	dev-ml/findlib"

src_compile() {
	ocaml pkg/pkg.ml build --tests $(usex test 'true' 'false') || die
}

src_test() {
	ocaml pkg/pkg.ml test || die
}

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		${PN}.install || die
	dodoc CHANGES.md README.md
}
