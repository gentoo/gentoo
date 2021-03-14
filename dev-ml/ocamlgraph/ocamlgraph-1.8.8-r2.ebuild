# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit findlib

DESCRIPTION="O'Caml Graph library"
HOMEPAGE="http://ocamlgraph.lri.fr/index.en.html"
SRC_URI="http://ocamlgraph.lri.fr/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="amd64 arm ~arm64 ppc ppc64 x86"
IUSE="doc examples gtk +ocamlopt"

RDEPEND="
	>=dev-lang/ocaml-3.10.2:=[ocamlopt?]
	gtk? ( dev-ml/lablgtk:2=[gnomecanvas,ocamlopt?] )
"
DEPEND="${RDEPEND}"
BDEPEND="doc? ( dev-tex/hevea dev-ml/ocamlweb )"

src_compile() {
	emake byte
	use ocamlopt && emake opt

	if use doc; then
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

	dodoc README.adoc CREDITS FAQ CHANGES

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	if use doc; then
		docinto html
		dodoc doc/*
	fi
}
