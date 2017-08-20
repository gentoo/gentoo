# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit findlib

DESCRIPTION="An OCaml lexer generator for Unicode"
HOMEPAGE="https://github.com/alainfrisch/sedlex"
SRC_URI="https://github.com/alainfrisch/sedlex/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

DEPEND="
	dev-lang/ocaml:=[ocamlopt?]
	dev-ml/gen:=[ocamlopt(+)?]
	dev-ml/ppx_tools_versioned:=[ocamlopt(+)?]
	dev-ml/ocaml-migrate-parsetree:=[ocamlopt(+)?]
"
RDEPEND="${DEPEND}"

src_compile() {
	emake all
	use ocamlopt && emake opt
}

src_test() {
	emake -j1 test
}

src_install() {
	findlib_src_preinst
	if use ocamlopt; then
		emake install
	else
		emake install_byteonly
	fi
	dodoc CHANGES README.md
}
