# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit opam

DESCRIPTION="Streaming XML codec for OCaml"
HOMEPAGE="http://erratique.ch/software/xmlm"
SRC_URI="http://erratique.ch/software/xmlm/releases/xmlm-1.3.0.tbz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt"

BDEPEND="
	dev-ml/findlib[ocamlopt=]
	dev-ml/ocamlbuild[ocamlopt=]
	dev-ml/topkg
"

src_compile() {
	ocaml pkg/pkg.ml build || die
}
