# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="Non-blocking streaming JSON codec for OCaml"
HOMEPAGE="http://erratique.ch/software/jsonm"
SRC_URI="http://erratique.ch/software/jsonm/releases/${P}.tbz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-ml/uutf:=
	dev-lang/ocaml:=
	dev-ml/uchar:="
DEPEND="${RDEPEND}
	dev-ml/topkg
	dev-ml/opam
	dev-ml/ocamlbuild
	dev-ml/findlib"

DOCS=( CHANGES README )

src_compile() {
	ocaml pkg/pkg.ml build || die
}

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		${PN}.install || die
	dodoc CHANGES.md TODO.md README.md
}
