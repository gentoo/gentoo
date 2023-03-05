# Copyright 1999-2023 Gentoo Authors
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
RESTRICT="test" # ocaml-crunch not in the tree

RDEPEND="
	>=dev-ml/dune-3
	dev-ml/astring:=
	dev-ml/cmdliner:=
	dev-ml/cppo:=
	dev-ml/fmt:=
	dev-ml/fpath:=
	dev-ml/odoc-parser:=
	dev-ml/result:=
	dev-ml/tyxml:=
"
DEPEND="${RDEPEND}"
