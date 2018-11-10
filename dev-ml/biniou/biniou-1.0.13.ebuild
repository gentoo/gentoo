# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit findlib

DESCRIPTION="A binary data serialization format inspired by JSON for OCaml"
HOMEPAGE="https://github.com/mjambon/biniou"
SRC_URI="https://github.com/mjambon/biniou/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0/${PV}"
LICENSE="BSD"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

RDEPEND=">=dev-lang/ocaml-3.11:=[ocamlopt?]
	dev-ml/easy-format:=[ocamlopt?]
"
DEPEND="${RDEPEND}"

src_compile() {
	emake all
	use ocamlopt && emake opt
}

src_install() {
	use ocamlopt && dodir /usr/bin
	findlib_src_install BINDIR="${ED}"/usr/bin
	dodoc README.md Changes
}
