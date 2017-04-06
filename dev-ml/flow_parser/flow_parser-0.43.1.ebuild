# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit findlib

DESCRIPTION="JavaScript parser written in OCaml"
HOMEPAGE="https://github.com/facebook/flow/tree/master/src/parser"
SRC_URI="https://github.com/facebook/flow/archive/v${PV}.tar.gz -> flow-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-lang/ocaml:="
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	dev-ml/ocamlbuild"

S="${WORKDIR}/flow-${PV}/src/parser"

src_compile() {
	ocamlbuild parser_flow.cma parser_flow.cmxa || die
}

src_test() {
	emake test-ocaml
}

src_install() {
	findlib_src_preinst
	emake ocamlfind-install
	dodoc README.md
}
