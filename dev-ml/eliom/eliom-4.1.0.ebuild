# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib findlib

DESCRIPTION="A web framework to program client/server applications"
HOMEPAGE="http://ocsigen.org/eliom/"
SRC_URI="https://github.com/ocsigen/eliom/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="doc +ocamlopt"

DEPEND=">=dev-lang/ocaml-4.00:=[ocamlopt?]
	>=dev-ml/js_of_ocaml-2.5-r1:=
	>=www-servers/ocsigenserver-2.5:=
	>=dev-ml/tyxml-3.3:=
	>=dev-ml/deriving-0.6:=
	dev-ml/reactiveData:=
	dev-ml/ocaml-ipaddr:=
	dev-ml/react:=
	dev-ml/ocaml-ssl:=
	dev-ml/calendar:="
RDEPEND="${DEPEND}
	dev-ml/opam"

src_compile() {
	if use ocamlopt ; then
		emake all
	else
		emake byte
	fi
	use doc && emake doc
	emake man
}

src_install() {
	opam-installer \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		|| die
	dodoc CHANGES README
	if use doc ; then
		docinto client/html
		dodoc -r _build/src/lib/client/api.docdir/*
		docinto server/html
		dodoc -r _build/src/lib/server/api.docdir/*
	fi
}
