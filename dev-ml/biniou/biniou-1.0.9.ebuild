# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit findlib

DESCRIPTION="A binary data serialization format inspired by JSON for OCaml"
HOMEPAGE="http://mjambon.com/biniou.html"
SRC_URI="http://mjambon.com/releases/${PN}/${P}.tar.gz"

SLOT="0/${PV}"
LICENSE="BSD"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

RDEPEND=">=dev-lang/ocaml-3.11:=[ocamlopt?]
	dev-ml/easy-format:=[ocamlopt?]
"
DEPEND="${RDEPEND}"

src_compile() {
	emake -j1 all
	use ocamlopt && emake -j1 opt
}

src_install() {
	use ocamlopt && dodir /usr/bin
	findlib_src_install BINDIR="${ED}"/usr/bin
	dodoc README.md Changes
}
