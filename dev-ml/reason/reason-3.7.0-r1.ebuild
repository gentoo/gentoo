# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Simple, fast & type safe language that leverages JavaScript and OCaml"
HOMEPAGE="https://reasonml.github.io"
SRC_URI="https://registry.npmjs.org/@esy-ocaml/${PN}/-/${P}.tgz"
S="${WORKDIR}/package"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

RDEPEND="
	dev-ml/fix:=
	dev-ml/menhir:=
	dev-ml/merlin-extend:=
	dev-ml/ocaml-migrate-parsetree:=
	dev-ml/result:=
	dev-ml/utop:=
"
DEPEND="${RDEPEND}"

src_install() {
	dune_src_install reason
	dune_src_install rtop

	dodoc *.md
}
