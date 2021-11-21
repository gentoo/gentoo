# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="LR(1) parser generator for the OCaml language"
HOMEPAGE="http://gallium.inria.fr/~fpottier/menhir/"
SRC_URI="https://gitlab.inria.fr/fpottier/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="+ocamlopt"

src_install() {
	dune_src_install menhir
	dune_src_install menhirLib
	dune_src_install menhirSdk
}
