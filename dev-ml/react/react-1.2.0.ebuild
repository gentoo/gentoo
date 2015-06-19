# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/react/react-1.2.0.ebuild,v 1.1 2014/10/29 09:23:44 aballier Exp $

EAPI="5"

DESCRIPTION="OCaml module for functional reactive programming"
HOMEPAGE="http://erratique.ch/software/react"
SRC_URI="http://erratique.ch/software/react/releases/${P}.tbz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86-fbsd"
IUSE="doc +ocamlopt"

RDEPEND=">=dev-lang/ocaml-3.12:=[ocamlopt?]"
DEPEND="${RDEPEND}
	dev-ml/findlib
	dev-ml/opam
"

src_compile() {
	pkg/build.ml \
		native=$(usex ocamlopt true false) \
		native-dynlink=$(usex ocamlopt true false) \
		|| die
}

src_test() {
	if use ocamlopt ; then
		ocamlbuild tests.otarget || die
		cd _build/test || die
		./test.native || die
	else
		ewarn "Sorry, ${PN} tests require native support (ocamlopt)"
	fi
}

src_install() {
	opam-installer \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		|| die
	dodoc CHANGES.md README.md TODO.md
	use doc && dohtml doc/*
}
