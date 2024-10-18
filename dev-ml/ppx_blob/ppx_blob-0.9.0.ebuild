# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Include a file as a string at compile time"
HOMEPAGE="https://github.com/johnwhitington/ppx_blob"
SRC_URI="https://github.com/johnwhitington/${PN}/releases/download/${PV}/${P}.tbz"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

DEPEND="dev-ml/ppxlib:=[ocamlopt?]"
RDEPEND="${DEPEND}"
BDEPEND="test? ( dev-ml/alcotest )"
