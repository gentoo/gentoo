# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit findlib

DESCRIPTION="Inline (Unit) Tests for OCaml"
HOMEPAGE="https://github.com/vincent-hugot/iTeML"
SRC_URI="https://github.com/vincent-hugot/iTeML/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-ml/ounit:=
	dev-lang/ocaml:=[ocamlopt]
	>=dev-ml/qcheck-0.5:=
"
DEPEND="${RDEPEND}
	dev-ml/ocamlbuild
"

src_install() {
	findlib_src_preinst
	dodir /usr/bin
	emake BIN="${ED}/usr/bin/" install
	dodoc README.adoc HOWTO.adoc
}
