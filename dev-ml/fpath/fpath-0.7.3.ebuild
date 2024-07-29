# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit opam

DESCRIPTION="File system paths for OCaml"
HOMEPAGE="https://erratique.ch/software/fpath https://github.com/dbuenzli/fpath"
SRC_URI="https://erratique.ch/software/fpath/releases/${P}.tbz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ~ppc ppc64 ~riscv x86"

RDEPEND="dev-ml/result:=
	dev-ml/astring:=
"
DEPEND="${RDEPEND}"
BDEPEND="dev-ml/topkg
	dev-ml/ocamlbuild
	dev-ml/findlib"

src_compile() {
	ocaml pkg/pkg.ml build || die
}
