# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit opam

DESCRIPTION="Alternative String module for OCaml"
HOMEPAGE="https://erratique.ch/software/astring https://github.com/dbuenzli/astring"
SRC_URI="https://erratique.ch/software/astring/releases/${P}.tbz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-lang/ocaml:=[ocamlopt]"
DEPEND="${RDEPEND}
	dev-ml/topkg
	dev-ml/ocamlbuild
	dev-ml/findlib"

src_compile() {
	ocaml pkg/pkg.ml build || die
}
