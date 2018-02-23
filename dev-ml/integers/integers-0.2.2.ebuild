# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Various signed and unsigned integer types for OCaml"
HOMEPAGE="https://github.com/ocamllabs/ocaml-integers"
SRC_URI="https://github.com/ocamllabs/ocaml-integers/releases/download/v${PV}/${P}.tbz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

RDEPEND="dev-lang/ocaml:="
DEPEND="${RDEPEND}
	dev-ml/ocamlbuild
	dev-ml/opam
	dev-ml/topkg
	dev-ml/findlib"

src_compile() {
	ocaml pkg/pkg.ml build || die
}

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		${PN}.install || die
}
