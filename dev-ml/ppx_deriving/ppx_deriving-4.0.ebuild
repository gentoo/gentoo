# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit findlib

DESCRIPTION="Type-driven code generation for OCaml"
HOMEPAGE="https://github.com/whitequark/ppx_deriving"
SRC_URI="https://github.com/whitequark/ppx_deriving/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="doc +ocamlopt test"

DEPEND="dev-ml/ppx_tools:=
	>=dev-lang/ocaml-4.02.3:=[ocamlopt?]"
RDEPEND="${DEPEND}"
DEPEND="${RDEPEND}
	dev-ml/opam
	test? ( dev-ml/ounit )"

src_compile() {
	cp pkg/META.in pkg/META || die
	ocaml pkg/build.ml \
		native=$(usex ocamlopt true false) \
		native-dynlink=$(usex ocamlopt true false) \
		|| die
	use doc && emake doc
}

src_test() {
	ocamlbuild -j 0 -use-ocamlfind -classic-display \
			src_test/test_ppx_deriving.byte -- || die
	if use ocamlopt;  then
		ocamlbuild -j 0 -use-ocamlfind -classic-display \
			src_test/test_ppx_deriving.native -- || die
	fi
}

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		${PN}.install || die
	mv "${ED}/usr/lib/ppx_deriving/ppx_deriving" "${D}/$(ocamlc -where)/ppx_deriving/" || die

	use doc && dohtml api.docdir/*

	dodoc CHANGELOG.md README.md
}
