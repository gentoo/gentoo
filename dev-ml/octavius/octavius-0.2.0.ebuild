# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit findlib

DESCRIPTION="ocamldoc comment syntax parser"
HOMEPAGE="https://github.com/ocaml-doc/octavius"
SRC_URI="https://github.com/ocaml-doc/octavius/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="dev-lang/ocaml:="
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	dev-ml/topkg
	dev-ml/opam
	dev-ml/ocamlbuild"

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
}
