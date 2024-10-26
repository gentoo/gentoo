# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit opam

DESCRIPTION="Heterogeneous value maps for OCaml"
HOMEPAGE="http://erratique.ch/software/hmap"
SRC_URI="http://erratique.ch/software/${PN}/releases/${P}.tbz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-ml/ocamlbuild
	dev-ml/findlib
	dev-ml/topkg
"

src_compile() {
	ocaml pkg/pkg.ml build || die
}
