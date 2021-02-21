# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit opam

DESCRIPTION="Alternative String module for OCaml"
HOMEPAGE="https://erratique.ch/software/astring https://github.com/dbuenzli/astring"
SRC_URI="https://erratique.ch/software/astring/releases/${P}.tbz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

OCAML_DEP=">=dev-lang/ocaml-4.05.0:="
BDEPEND="
	dev-ml/ocamlbuild
	dev-ml/findlib
	dev-ml/topkg
	${OCAML_DEP}
"
RDEPEND="${OCAML_DEP}"

src_compile() {
	ocaml pkg/pkg.ml build || die
}
