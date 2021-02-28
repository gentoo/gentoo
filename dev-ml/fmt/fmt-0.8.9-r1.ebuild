# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit findlib opam

DESCRIPTION="Combinators to devise OCaml Format pretty-printing functions"
HOMEPAGE="https://erratique.ch/software/fmt https://github.com/dbuenzli/fmt"
SRC_URI="https://erratique.ch/software/fmt/releases/${P}.tbz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-ml/cmdliner:=[ocamlopt]
	dev-lang/ocaml:=[ocamlopt]
	dev-ml/result:=[ocamlopt]
	dev-ml/stdlib-shims:=[ocamlopt]
	dev-ml/uchar:=[ocamlopt]
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-ml/topkg-0.9
	dev-ml/ocamlbuild
	dev-ml/findlib
"

src_compile() {
	ocaml pkg/pkg.ml build --tests $(usex test 'true' 'false') || die
}

src_test() {
	ocaml pkg/pkg.ml test || die
}
