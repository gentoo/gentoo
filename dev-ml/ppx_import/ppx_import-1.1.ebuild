# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A syntax extension for importing declarations from interface files"
HOMEPAGE="https://github.com/whitequark/ppx_impor://github.com/whitequark/ppx_import"
SRC_URI="https://github.com/whitequark/ppx_import/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt test"

DEPEND="
	dev-lang/ocaml:=[ocamlopt?]
	dev-ml/ppx_tools:=
	dev-ml/cppo:=
"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	test? ( dev-ml/ounit dev-ml/ppx_deriving )
	dev-ml/opam
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

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${T}/dontinstallit" \
		${PN}.install || die
	dodoc CHANGELOG.md README.md
}
