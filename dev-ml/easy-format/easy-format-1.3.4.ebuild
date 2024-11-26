# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Pretty-printing library for OCaml"
HOMEPAGE="https://github.com/ocaml-community/easy-format"
SRC_URI="https://github.com/ocaml-community/${PN}/releases/download/${PV}/${P}.tbz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt"
