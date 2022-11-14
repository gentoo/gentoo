# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

GH_TS="1668377184" # https://bugs.gentoo.org/881037 - bump this UNIX timestamp if the downloaded file changes checksum

DESCRIPTION="Simple, fast & type safe language that leverages JavaScript and OCaml"
HOMEPAGE="https://reasonml.github.io"
SRC_URI="https://github.com/reasonml/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.gh@${GH_TS}.tar.gz"

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

DOCS=(
	CODE_OF_CONDUCT.md HISTORY.md ORIGINS.md PLAN README.md
	docs/GETTING_STARTED_CONTRIBUTING.md
	docs/TYPE_PARAMETERS_PARSING.md
	docs/USING_PARSER_PROGRAMMATICALLY.md
)

src_install() {
	dune-install reason rtop
	einstalldocs
}
