# Copyright 1999-2023 Gentoo Authors
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
RESTRICT="!test? ( test )"

RDEPEND="
	dev-ml/cmdliner:=
	dev-ml/uucp:=
	dev-ml/uutf:=
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
