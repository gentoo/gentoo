# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit opam

DESCRIPTION="Streaming XML codec for OCaml"
HOMEPAGE="https://erratique.ch/software/xmlm"
SRC_URI="https://erratique.ch/software/${PN}/releases/${P}.tbz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

DEPEND="${RDEPEND}
	dev-ml/topkg
	dev-ml/ocamlbuild
	dev-ml/findlib"

src_compile() {
	ocaml pkg/pkg.ml build || die
}
