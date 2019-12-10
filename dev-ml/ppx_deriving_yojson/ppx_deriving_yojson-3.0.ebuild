# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils opam

DESCRIPTION="A Yojson codec generator for OCaml"
HOMEPAGE="https://github.com/whitequark/ppx_deriving_yojson/"
SRC_URI="https://github.com/whitequark/ppx_deriving_yojson/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-lang/ocaml:=[ocamlopt?]
	dev-ml/yojson:=
	dev-ml/result:=
	>=dev-ml/ppx_deriving-4:=
	dev-ml/cppo:=
"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	dev-ml/findlib
	dev-ml/ocamlbuild
	test? ( dev-ml/ounit dev-ml/ppx_import )"

src_prepare() {
	has_version '>=dev-lang/ocaml-4.05_rc' && epatch "${FILESDIR}/ocaml405.patch"
}

src_compile() {
	cp pkg/META.in pkg/META
	ocaml pkg/build.ml \
		native=$(usex ocamlopt true false) \
		native-dynlink=$(usex ocamlopt true false) \
		|| die
}

src_test() {
	ocamlbuild -j 0 -use-ocamlfind -classic-display src_test/test_ppx_yojson.byte -- || die
}
