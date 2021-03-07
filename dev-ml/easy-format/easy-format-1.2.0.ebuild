# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit findlib

DESCRIPTION="Pretty-printing library for OCaml"
HOMEPAGE="https://github.com/mjambon/easy-format"
SRC_URI="https://github.com/mjambon/easy-format/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0/${PV}"
LICENSE="BSD"
KEYWORDS="~amd64"

IUSE="examples +ocamlopt"

RDEPEND="dev-lang/ocaml:=[ocamlopt?]"
DEPEND="${RDEPEND}"

src_compile() {
	emake all
	use ocamlopt && emake opt
}

src_install() {
	findlib_src_install
	dodoc README.md Changes
	if use examples ; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
