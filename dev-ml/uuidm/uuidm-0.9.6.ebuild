# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit findlib

DESCRIPTION="OCaml module implementing 128 bits universally unique identifiers"
HOMEPAGE="http://erratique.ch/software/uuidm"
SRC_URI="http://erratique.ch/software/uuidm/releases/${P}.tbz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-lang/ocaml:=
	dev-ml/cmdliner:="
DEPEND="${RDEPEND}
	dev-ml/opam"

src_compile() {
	ocaml pkg/pkg.ml build || die
}

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		${PN}.install || die
	dodoc CHANGES.md README.md
}
