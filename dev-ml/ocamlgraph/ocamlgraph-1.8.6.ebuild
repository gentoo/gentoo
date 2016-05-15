# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit findlib eutils

DESCRIPTION="O'Caml Graph library"
HOMEPAGE="http://ocamlgraph.lri.fr/index.en.html"
SRC_URI="http://ocamlgraph.lri.fr/download/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~x86"
RDEPEND=">=dev-lang/ocaml-3.10.2:=[ocamlopt?]
	gtk? ( dev-ml/lablgtk:=[gnomecanvas,ocamlopt?] )"
DEPEND="${RDEPEND}
	doc? ( dev-tex/hevea dev-ml/ocamlweb )"
IUSE="doc examples gtk +ocamlopt"

src_prepare() {
	epatch "${FILESDIR}/${P}-installfindlib.patch"
}

src_compile() {
	emake byte
	use ocamlopt && emake opt

	if use doc;	then
		emake doc
	fi

	if use gtk; then
		emake OCAMLBEST=$(usex ocamlopt opt byte) viewer dgraph editor
	fi
}

src_install() {
	findlib_src_preinst
	use ocamlopt || export WANT_OCAMLOPT=no
	use gtk && export WANT_GTK=yes
	emake install-findlib

	if use gtk ; then
		local ext=byte
		use ocamlopt && ext=opt
		newbin dgraph/dgraph.${ext} ${PN}-dgraph
		newbin editor/editor.${ext} ${PN}-editor
		newbin view_graph/viewgraph.${ext} ${PN}-viewgraph
	fi

	dodoc README CREDITS FAQ CHANGES
	if use doc; then
		dohtml doc/*
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
