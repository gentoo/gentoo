# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit findlib

DESCRIPTION="Syntax for cross-language type definitions"
HOMEPAGE="https://github.com/mjambon/atd"
SRC_URI="https://github.com/mjambon/atd/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

DEPEND="
	dev-lang/ocaml:=[ocamlopt?]
	dev-ml/easy-format:=[ocamlopt?]
	dev-ml/menhir:=[ocamlopt?]
"
RDEPEND="${DEPEND}"

src_compile() {
	emake -j1 all
	use ocamlopt && emake opt
}

src_install() {
	dodir /usr/bin
	PREFIX="${ED}/usr" findlib_src_install
	dodoc README.md
}
