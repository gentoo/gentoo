# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

DESCRIPTION="A lightweight and colourful test framework"
HOMEPAGE="https://github.com/mirage/alcotest/"
SRC_URI="https://github.com/mirage/alcotest/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	dev-lang/ocaml:=[ocamlopt]
	dev-ml/fmt:=
	dev-ml/astring:=
	dev-ml/cmdliner:=
	dev-ml/result:=
"
DEPEND="${RDEPEND}
	dev-ml/opam
	dev-ml/topkg
	dev-ml/ocamlbuild
	dev-ml/findlib"

src_compile() {
	ocaml pkg/pkg.ml build --tests $(usex test true false) || die
}

src_test() {
	ocaml pkg/pkg.ml test || die
}

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		${PN}.install || die
	dodoc CHANGES.md README.md
}
