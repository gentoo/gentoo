# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit findlib

DESCRIPTION="Non-blocking streaming Unicode codec for OCaml"
HOMEPAGE="http://erratique.ch/software/uutf"
SRC_URI="http://erratique.ch/software/uutf/releases/${P}.tbz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="doc utftrip +ocamlopt test"

RDEPEND=">=dev-lang/ocaml-3.12:=[ocamlopt?]
	utftrip? ( dev-ml/cmdliner:= )"
DEPEND="${RDEPEND}
	test? ( dev-ml/cmdliner )"

src_compile() {
	ocaml pkg/build.ml \
		native=$(usex ocamlopt true false) \
		native-dynlink=$(usex ocamlopt true false) \
		cmdliner=$(usex utftrip true false) \
		|| die
}

src_test() {
	if use ocamlopt ; then
		ocamlbuild -use-ocamlfind tests.otarget || die
		cd _build/test || die
		./test.native || die
	else
		ewarn "Sorry, ${PN} tests require native support (ocamlopt)"
	fi
}

src_install() {
	# Can't use opam-installer here as it is an opam dep...
	findlib_src_preinst
	local nativelibs=""
	use ocamlopt && nativelibs="$(echo _build/src/uutf.cm{x,xa,xs} _build/src/uutf.a)"
	ocamlfind install uutf _build/pkg/META _build/src/uutf.mli _build/src/uutf.cm{a,i} ${nativelibs} || die
	use utftrip && newbin utftrip.$(usex ocamlopt native byte) utftrip
	dodoc CHANGES.md README.md
	use doc && dohtml -r doc/*
}
