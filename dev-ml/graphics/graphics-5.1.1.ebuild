# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="The OCaml graphics library"
HOMEPAGE="https://github.com/ocaml/graphics"
SRC_URI="https://github.com/ocaml/${PN}/releases/download/${PV}/${P}.tbz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

RDEPEND="dev-ml/dune-configurator:=[ocamlopt?]
	>=dev-lang/ocaml-4.09
	x11-libs/libX11:="
DEPEND="${RDEPEND}"
BDEPEND=""

IUSE="+ocamlopt"
