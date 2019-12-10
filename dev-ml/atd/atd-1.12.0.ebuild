# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit findlib

DESCRIPTION="Syntax for cross-language type definitions"
HOMEPAGE="https://github.com/mjambon/atd"
SRC_URI="https://github.com/mjambon/atd/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-lang/ocaml:=[ocamlopt?]
	dev-ml/easy-format:=[ocamlopt?]
	dev-ml/menhir:=[ocamlopt?]
"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	dev-ml/jbuilder
	dev-ml/opam
	test? (
		dev-ml/biniou
		dev-ml/yojson
	)
"

src_compile() {
	jbuilder build -p atd || die
}

oinstall() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		${1}.install || die
}

src_install() {
	oinstall atd
}
