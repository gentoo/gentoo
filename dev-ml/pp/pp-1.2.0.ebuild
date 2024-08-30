# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Pretty-printing library"
HOMEPAGE="https://github.com/ocaml-dune/pp"
SRC_URI="https://github.com/ocaml-dune/pp/releases/download/${PV}/${P}.tbz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( dev-ml/ppx_expect )"
