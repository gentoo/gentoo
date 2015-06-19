# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/js_of_ocaml/js_of_ocaml-2.5.ebuild,v 1.1 2014/12/01 09:50:16 aballier Exp $

EAPI=5

inherit findlib

DESCRIPTION="A compiler from OCaml bytecode to javascript"
HOMEPAGE="http://ocsigen.org/js_of_ocaml/"
SRC_URI="https://github.com/ocsigen/js_of_ocaml/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt doc +deriving"

DEPEND=">=dev-lang/ocaml-3.12:=[ocamlopt?]
	>=dev-ml/lwt-2.4.0:=
	dev-ml/react:=
	>=dev-ml/tyxml-3.3:=
	dev-ml/cmdliner:=
	dev-ml/menhir:=
	|| ( dev-ml/camlp4:= <dev-lang/ocaml-4.02.0 )
	deriving? ( >=dev-ml/deriving-0.6:= )"
RDEPEND="${DEPEND}"

src_configure() {
	use ocamlopt || echo "BEST := byte" >> Makefile.conf
	use deriving || echo "WITH_DERIVING := NO" >> Makefile.conf
}

src_compile() {
	emake -j1
	use doc && emake doc
}

src_install() {
	findlib_src_preinst
	emake BINDIR="${ED}/usr/bin/" install
	dodoc CHANGES README.md
	use doc && dohtml -r doc/api/html/
}
