# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit opam

DESCRIPTION="Unicode text segmentation for OCaml"
HOMEPAGE="https://erratique.ch/software/uuseg/
	https://github.com/dbuenzli/uuseg/"
SRC_URI="https://github.com/dbuenzli/uuseg/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt test"
RESTRICT="test"

RDEPEND="
	>=dev-lang/ocaml-4.14:=
	dev-ml/cmdliner:=[ocamlopt?]
	dev-ml/uucp:=
	dev-ml/uutf:=[ocamlopt?]
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-ml/ocamlbuild
	dev-ml/findlib
	dev-ml/topkg
"

src_compile() {
	ocaml pkg/pkg.ml build --tests $(usex test true false) || die
}

src_test() {
	ocaml pkg/pkg.ml test || die
}
