# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="An equivalent of the C preprocessor for OCaml programs"
HOMEPAGE="https://github.com/ocaml-community/cppo/"
SRC_URI="https://github.com/ocaml-community/cppo/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0/${PV}"
LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

IUSE="+ocamlopt"

RDEPEND="dev-ml/ocamlbuild"
DEPEND="${RDEPEND}"
