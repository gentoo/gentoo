# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit findlib

DESCRIPTION="Syntax for cross-language type definitions"
HOMEPAGE="https://github.com/mjambon/atd"
SRC_URI="https://github.com/mjambon/atd/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

DEPEND="
	dev-lang/ocaml:=[ocamlopt?]
	dev-ml/easy-format:=[ocamlopt?]
	dev-ml/menhir:=[ocamlopt?]
	dev-ml/biniou:=
	dev-ml/yojson:=
	!dev-ml/atdgen
"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	dev-ml/jbuilder
	dev-ml/opam
"

oinstall() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		${1}.install || die
}

src_install() {
	oinstall atd
	oinstall atdgen
}
