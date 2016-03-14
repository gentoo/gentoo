# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools findlib

DESCRIPTION="OCaml hash-consing library"
HOMEPAGE="https://github.com/backtracking/ocaml-hashcons"
SRC_URI="https://github.com/backtracking/ocaml-hashcons/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

RDEPEND="dev-lang/ocaml:=[ocamlopt?]"
DEPEND="${RDEPEND}"

src_prepare() {
	eautoreconf
	sed -i -e 's/$(OCAMLFIND) remove/#/' Makefile.in || die
}

src_compile() {
	if use ocamlopt; then
		emake opt byte
	else
		emake byte
	fi
}

src_install() {
	dodir "$(ocamlfind printconf destdir)/hashcons"
	emake DESTDIR="-destdir ${D}/$(ocamlfind printconf destdir)/" $(usex ocamlopt install-opt install-byte)
	dodoc README.md CHANGES
}
