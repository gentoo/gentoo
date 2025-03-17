# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="An equivalent of the C preprocessor for OCaml programs"
HOMEPAGE="https://github.com/ocaml-community/cppo/"
SRC_URI="https://github.com/ocaml-community/cppo/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt"

RDEPEND="dev-ml/ocamlbuild:=
	dev-ml/findlib:="
DEPEND="${RDEPEND}"
