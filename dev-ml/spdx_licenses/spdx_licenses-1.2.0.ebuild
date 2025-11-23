# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="A library providing a strict SPDX License Expression parser"
HOMEPAGE="https://github.com/kit-ty-kate/spdx_licenses"
SRC_URI="https://github.com/kit-ty-kate/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

IUSE="+ocamlopt test"

BDEPEND="test? ( dev-ml/alcotest )"

RESTRICT="!test? ( test )"
