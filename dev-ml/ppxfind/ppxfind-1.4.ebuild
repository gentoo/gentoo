# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="ocamlfind ppx tool"
HOMEPAGE="https://github.com/diml/ppxfind"
SRC_URI="https://github.com/diml/ppxfind/releases/download/${PV}/${P}.tbz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="+ocamlopt"

DEPEND="
	<=dev-ml/ocaml-migrate-parsetree-1.80:=
	dev-ml/findlib:=
"
RDEPEND="${DEPEND}"
