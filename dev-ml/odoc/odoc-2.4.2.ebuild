# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="OCaml documentation generator"
HOMEPAGE="http://github.com/ocaml/odoc/"
SRC_URI="https://github.com/ocaml/${PN}/releases/download/${PV}/${P}.tbz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+ocamlopt test"
RESTRICT="test"

RDEPEND="
	dev-ml/astring:=
	dev-ml/cmdliner:=[ocamlopt?]
	~dev-ml/odoc-parser-${PV}:=[ocamlopt?]
	dev-ml/fmt:=[ocamlopt?]
	dev-ml/fpath:=
	dev-ml/ocaml-crunch:=[ocamlopt?]
	dev-ml/result:=[ocamlopt?]
	dev-ml/tyxml:=[ocamlopt?]
"
DEPEND="${RDEPEND}
	dev-ml/cppo:=[ocamlopt?]
"
BDEPEND=">=dev-ml/dune-3.7"

src_compile() {
	dune-compile ${PN}
}
