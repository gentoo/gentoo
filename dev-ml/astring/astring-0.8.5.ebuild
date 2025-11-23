# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit opam

DESCRIPTION="Alternative String module for OCaml"
HOMEPAGE="https://erratique.ch/software/astring https://github.com/dbuenzli/astring"
SRC_URI="https://erratique.ch/software/astring/releases/${P}.tbz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ~ppc ppc64 ~riscv x86"

BDEPEND="
	dev-ml/ocamlbuild
	dev-ml/findlib
	dev-ml/topkg
"

src_compile() {
	ocaml pkg/pkg.ml build || die
}
