# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit opam

DESCRIPTION="Universally unique identifiers (UUIDs) for OCaml"
HOMEPAGE="https://github.com/dbuenzli/uuidm/"
SRC_URI="https://github.com/dbuenzli/uuidm/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64 arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt"

BDEPEND="
	dev-ml/findlib[ocamlopt=]
	dev-ml/ocamlbuild[ocamlopt=]
	dev-ml/topkg
"

src_compile() {
	ocaml pkg/pkg.ml build || die
}
