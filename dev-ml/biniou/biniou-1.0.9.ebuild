# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/biniou/biniou-1.0.9.ebuild,v 1.1 2015/02/15 09:15:59 aballier Exp $

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
