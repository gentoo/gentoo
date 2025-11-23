# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Opam solver using 0install backend using the CUDF interface"
HOMEPAGE="https://github.com/ocaml-opam/opam-0install-cudf"
SRC_URI="https://github.com/ocaml-opam/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-ml/0install:=[ocamlopt?]
	dev-ml/cudf:=[ocamlopt?]
	dev-ml/extlib:=[ocamlopt?]
"
BDEPEND="test? ( dev-ml/alcotest )"

src_configure() {
	:
}
