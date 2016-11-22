# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Uchar compatibility library"
HOMEPAGE="https://github.com/ocaml/uchar"
SRC_URI="https://github.com/ocaml/uchar/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

RDEPEND="dev-lang/ocaml:="
DEPEND="${RDEPEND}
	dev-ml/opam"

src_compile() {
	ocaml pkg/build.ml \
		"native=$(usex ocamlopt true false)" \
		"native-dynlink=$(usex ocamlopt true false)" || die
}

src_test() {
	ocamlbuild -X src -use-ocamlfind -pkg uchar test/testpkg.native || die
}

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		${PN}.install || die
	dodoc README.md CHANGES.md
}
