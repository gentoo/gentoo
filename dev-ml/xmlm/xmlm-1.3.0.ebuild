# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Ocaml XML manipulation module"
HOMEPAGE="http://erratique.ch/software/xmlm https://github.com/dbuenzli/xmlm"
SRC_URI="http://erratique.ch/software/${PN}/releases/${P}.tbz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND=">=dev-lang/ocaml-3.12:="
DEPEND="${RDEPEND}
	dev-ml/findlib
	dev-ml/opam
	>=dev-ml/topkg-0.9
"

src_compile() {
	ocaml pkg/pkg.ml build \
		--tests $(usex test 'true' 'false') \
		|| die
}

src_test() {
	ocaml pkg/pkg.ml test || die
}

src_install() {
	opam-installer \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		|| die
	dodoc CHANGES.md README.md
}
