# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit findlib eutils

DESCRIPTION="Standard library extensions for O'Caml"
HOMEPAGE="https://code.google.com/p/ocaml-extlib/"
SRC_URI="https://ocaml-extlib.googlecode.com/files/${P}.tar.gz"
LICENSE="LGPL-2.1"
DEPEND=">=dev-lang/ocaml-3.10.2:=[ocamlopt?]"
RDEPEND="${DEPEND}"
SLOT="0/${PV}"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc +ocamlopt"

src_compile() {
	emake all
	if use ocamlopt; then
		emake opt
	fi

	if use doc; then
		emake doc
	fi
}

src_install () {
	findlib_src_install

	# install documentation
	dodoc README.txt

	if use doc; then
		dohtml doc/*
	fi
}
