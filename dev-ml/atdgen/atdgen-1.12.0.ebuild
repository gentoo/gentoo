# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit findlib

DESCRIPTION="Generates boilerplate OCaml code for JSON and Biniou IO from type definitions"
HOMEPAGE="https://github.com/mjambon/atd"
SRC_URI="https://github.com/mjambon/atd/archive/v${PV}.tar.gz -> atd-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

DEPEND="
	dev-lang/ocaml:=[ocamlopt?]
	dev-ml/atd:=
	dev-ml/biniou:=
	dev-ml/yojson:=
"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	dev-ml/jbuilder
	dev-ml/opam
"

S="${WORKDIR}/atd-${PV}"

src_compile() {
	jbuilder build -p atdgen || die
}

oinstall() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		${1}.install || die
}

src_install() {
	oinstall atdgen
}
