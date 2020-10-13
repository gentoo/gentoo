# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="ocamlfind ppx tool"
HOMEPAGE="https://github.com/diml/ppxfind"
SRC_URI="https://github.com/diml/ppxfind/releases/download/${PV}/${P}.tbz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="+ocamlopt"

DEPEND="
	dev-ml/ocaml-migrate-parsetree:=
	dev-ml/findlib:=
"
RDEPEND="${DEPEND}"
