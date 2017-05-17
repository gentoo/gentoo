# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit findlib

DESCRIPTION="Generates optimized boilerplate OCaml code for JSON and Biniou IO from type definitions"
HOMEPAGE="https://github.com/mjambon/atdgen"
SRC_URI="https://github.com/mjambon/atdgen/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

DEPEND="
	dev-lang/ocaml:=[ocamlopt?]
	dev-ml/atd:=[ocamlopt?]
	dev-ml/biniou:=[ocamlopt?]
	dev-ml/yojson:=
"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	dev-ml/jbuilder
	dev-ml/opam
"

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		${PN}.install || die
}
