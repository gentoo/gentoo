# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit findlib eutils

DESCRIPTION="O'Caml Graph library"
HOMEPAGE="http://www.lri.fr/~filliatr/ocamlgraph/"
SRC_URI="http://www.lri.fr/~filliatr/ftp/ocamlgraph/${P}.tar.gz"
LICENSE="LGPL-2"
SLOT="0/${PV}"
KEYWORDS="~amd64 ppc x86"
RDEPEND=">=dev-lang/ocaml-3.10.2:=[ocamlopt?]
	gtk? ( dev-ml/lablgtk:=[gnomecanvas,ocamlopt?] )"
DEPEND="${RDEPEND}
	doc? ( dev-tex/hevea dev-ml/ocamlweb )"
IUSE="doc examples gtk +ocamlopt"

src_prepare() {
	epatch "${FILESDIR}/${P}-installfindlib.patch"
}

src_compile() {
	emake -j1

	if use doc;	then
		emake doc
	fi
	if use gtk; then
		emake -j1 editor
	fi
}

src_install() {
	findlib_src_preinst
	emake install-findlib

	if use gtk; then
		if use ocamlopt; then
			newbin editor/editor.opt ocamlgraph_editor
		else
			newbin editor/editor.byte ocamlgraph_editor
		fi
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
