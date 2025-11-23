# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DUNE_PKG_NAME="iostream iostream-camlzip"
inherit dune

DESCRIPTION="Generic, composable IO input and output streams"
HOMEPAGE="https://github.com/c-cube/ocaml-iostream"
SRC_URI="https://github.com/c-cube/ocaml-${PN}/releases/download/v${PV}/${P}.tbz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="dev-ml/camlzip:=[ocamlopt?]"
DEPEND="${RDEPEND}"
BDEPEND="test? ( dev-ml/ounit2 )"
