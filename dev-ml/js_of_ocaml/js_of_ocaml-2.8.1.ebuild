# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit findlib eutils

DESCRIPTION="A compiler from OCaml bytecode to javascript"
HOMEPAGE="http://ocsigen.org/js_of_ocaml/"
SRC_URI="https://github.com/ocsigen/js_of_ocaml/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+async +ocamlopt doc +deriving +ppx +ppx-deriving +react +xml X"

RDEPEND="
	>=dev-lang/ocaml-3.12:=[ocamlopt?,X?]
	>=dev-ml/lwt-2.4.4:=
	async? ( dev-ml/async_kernel:= )
	react? ( dev-ml/react:=  dev-ml/reactiveData:= )
	xml? ( >=dev-ml/tyxml-4:= )
	ppx? ( dev-ml/ppx_tools:= )
	ppx-deriving? ( dev-ml/ppx_deriving:= )
	dev-ml/cmdliner:=
	dev-ml/menhir:=
	dev-ml/ocaml-base64:=
	dev-ml/camlp4:=
	dev-ml/cppo:=
	deriving? ( >=dev-ml/deriving-0.6:= )"
DEPEND="${RDEPEND}
	dev-ml/ocamlbuild"

src_configure() {
	printf "\n\n" >> Makefile.conf
	use ocamlopt || echo "BEST := byte" >> Makefile.conf
	use ocamlopt || echo "NATDYNLINK := NO" >> Makefile.conf
	use deriving || echo "WITH_DERIVING := NO" >> Makefile.conf
	use X || echo "WITH_GRAPHICS := NO" >> Makefile.conf
	use react || echo "WITH_REACT := NO" >> Makefile.conf
	use ppx || echo "WITH_PPX := NO" >> Makefile.conf
	use ppx-deriving || echo "WITH_PPX_PPX_DERIVING := NO" >> Makefile.conf
	use async || echo "WITH_ASYNC := NO" >> Makefile.conf
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
