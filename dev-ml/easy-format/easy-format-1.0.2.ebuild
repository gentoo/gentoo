# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit findlib

DESCRIPTION="Pretty-printing library for OCaml"
HOMEPAGE="http://mjambon.com/easy-format.html"
SRC_URI="http://mjambon.com/releases/${PN}/${P}.tar.gz"

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
