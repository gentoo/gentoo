# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DUNE_PKG_NAME="odoc-parser"
inherit dune

MYP=odoc-${PV}

DESCRIPTION="Parser for ocaml documentation comments"
HOMEPAGE="https://github.com/ocaml-doc/odoc-parser"
SRC_URI="https://github.com/ocaml/odoc/archive/refs/tags/${PV}.tar.gz
	-> ${MYP}.tar.gz"

S="${WORKDIR}"/${MYP}

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt test"
RESTRICT="test"

RDEPEND="
	dev-ml/astring:=
	dev-ml/result:=[ocamlopt?]
	dev-ml/camlp-streams:=[ocamlopt?]
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-ml/dune-3.7
	test? (
		dev-ml/ppx_expect
	)
"

src_compile() {
	dune-compile ${PN}
}

src_test() {
	dune-test ${PN}
}
