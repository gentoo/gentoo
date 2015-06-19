# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/xmlm/xmlm-1.2.0.ebuild,v 1.1 2014/10/30 17:28:10 aballier Exp $

EAPI=5

DESCRIPTION="Ocaml XML manipulation module"
HOMEPAGE="http://erratique.ch/software/xmlm"
SRC_URI="http://erratique.ch/software/${PN}/releases/${P}.tbz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="doc +ocamlopt"

RDEPEND=">=dev-lang/ocaml-3.12:=[ocamlopt?]"
DEPEND="${RDEPEND}
	dev-ml/findlib
	dev-ml/opam
"

src_compile() {
	pkg/build \
		$(usex ocamlopt true false) \
		|| die
}

src_install() {
	opam-installer \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		|| die
	dodoc CHANGES.md README.md
	use doc && dohtml doc/*
}
