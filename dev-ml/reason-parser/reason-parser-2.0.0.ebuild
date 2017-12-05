# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit findlib eutils opam

DESCRIPTION="Meta Language Toolchain"
HOMEPAGE="https://github.com/facebook/reason"
SRC_URI="https://github.com/facebook/reason/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

DEPEND="
	>=dev-ml/menhir-20170418:=
	dev-ml/merlin-extend:=
	dev-ml/result:=
	dev-ml/topkg:=
	dev-ml/ocaml-migrate-parsetree:=
	dev-ml/ppx_tools_versioned:=
"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	dev-ml/ocamlbuild
"

S="${WORKDIR}/${PN}"

src_compile() {
	emake compile_error
	ocamlbuild -package topkg pkg/build.native || die
	./build.native build \
		--native "$(usex ocamlopt true false)" \
		--native-dynlink "$(usex ocamlopt true false)" \
		|| die
}
