# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="File system paths for OCaml"
HOMEPAGE="http://erratique.ch/software/fpath https://github.com/dbuenzli/fpath"
SRC_URI="http://erratique.ch/software/fpath/releases/${P}.tbz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-lang/ocaml:=
	dev-ml/result:=
	dev-ml/astring:=
"
DEPEND="${RDEPEND}
	dev-ml/topkg
	dev-ml/ocamlbuild
	dev-ml/findlib
"

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
