# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="A composable build system for OCaml"
HOMEPAGE="https://github.com/ocaml/dune"
SRC_URI="https://github.com/ocaml/dune/archive/${PV}.tar.gz -> dune-${PV}.tar.gz"
S="${WORKDIR}/dune-${PV}"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt"
RESTRICT="test"

BDEPEND="~dev-ml/dune-${PV}"
DEPEND="
	dev-ml/csexp:=[ocamlopt?]
	dev-ml/findlib:=[ocamlopt?]
	>=dev-lang/ocaml-4.09:=
"
RDEPEND="${DEPEND}"

src_prepare() {
	rm -r "${S}"/test || die

	default
}

src_configure() {
	:
}
