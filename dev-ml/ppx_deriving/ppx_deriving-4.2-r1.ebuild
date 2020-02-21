# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit findlib eutils opam

DESCRIPTION="Type-driven code generation for OCaml"
HOMEPAGE="https://github.com/ocaml-ppx/ppx_deriving"
SRC_URI="https://github.com/ocaml-ppx/ppx_deriving/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc +ocamlopt test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-ml/ppx_tools:=
	dev-ml/ocaml-migrate-parsetree:=
	dev-ml/ppx_derivers:=
	dev-ml/result:=
"
RDEPEND="${DEPEND}"
DEPEND="${RDEPEND}
	dev-ml/cppo
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
	opam_src_install
	mv "${ED}/usr/lib/ppx_deriving/ppx_deriving" "${D}/$(ocamlc -where)/ppx_deriving/" || die

	use doc && dohtml api.docdir/*
}
