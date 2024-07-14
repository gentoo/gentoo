# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Manipulate, parse and generate OCaml compiler version strings"
HOMEPAGE="https://github.com/ocurrent/ocaml-version"
SRC_URI="https://github.com/ocurrent/${PN}/releases/download/v${PV}/${P}.tbz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt test"

BDEPEND="test? ( dev-ml/alcotest:* )"
RESTRICT="!test? ( test )"
