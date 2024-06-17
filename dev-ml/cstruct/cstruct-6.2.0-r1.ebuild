# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Access C-like structures directly from OCaml"
HOMEPAGE="https://github.com/mirage/ocaml-cstruct"
SRC_URI="https://github.com/mirage/ocaml-cstruct/releases/download/v${PV}/${P}.tbz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

BDEPEND="test? (
		dev-ml/alcotest
		dev-ml/cppo
		dev-ml/ocaml-migrate-parsetree
		dev-ml/ppx_sexp_conv
		dev-ml/ppxlib
		dev-ml/sexplib
	)
"

src_compile() {
	dune-compile ${PN}
}
