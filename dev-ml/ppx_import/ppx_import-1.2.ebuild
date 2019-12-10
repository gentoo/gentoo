# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit opam

DESCRIPTION="A syntax extension for importing declarations from interface files"
HOMEPAGE="https://github.com/whitequark/ppx_import"
SRC_URI="https://github.com/whitequark/ppx_import/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-lang/ocaml:=[ocamlopt?]
	dev-ml/ppx_tools:=
	dev-ml/cppo:=
"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	test? ( dev-ml/ounit dev-ml/ppx_deriving )
	dev-ml/ocamlbuild
	dev-ml/findlib
"

src_compile() {
	cp pkg/META.in pkg/META
	ocaml pkg/build.ml \
		native=$(usex ocamlopt true false) \
		native-dynlink=$(usex ocamlopt true false) \
		|| die
}

src_test() {
	ocamlbuild -classic-display -use-ocamlfind src_test/test_ppx_import.byte --	|| die
}
