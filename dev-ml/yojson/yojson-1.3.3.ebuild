# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit findlib

DESCRIPTION="JSON parsing and pretty-printing library for OCaml"
HOMEPAGE="http://mjambon.com/yojson.html"
SRC_URI="https://github.com/mjambon/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0/${PV}"
LICENSE="BSD"
KEYWORDS="~amd64"
IUSE="examples"

RDEPEND=">=dev-lang/ocaml-3.11:=[ocamlopt]
	dev-ml/easy-format:=[ocamlopt]
	dev-ml/biniou:=[ocamlopt]
"
DEPEND="${RDEPEND}
	dev-ml/cppo
"

src_compile() {
	emake -j1
}

src_install() {
	dodir /usr/bin
	findlib_src_install BINDIR="${ED}"/usr/bin
	dodoc README.md Changes
	if use examples ; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
