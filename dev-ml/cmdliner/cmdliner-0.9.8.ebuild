# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit findlib

DESCRIPTION="Declarative definition of command line interfaces for OCaml"
HOMEPAGE="http://erratique.ch/software/cmdliner"
SRC_URI="http://erratique.ch/software/${PN}/releases/${P}.tbz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="doc +ocamlopt"

DEPEND=">=dev-lang/ocaml-4:=[ocamlopt?]"
RDEPEND="${DEPEND}"

src_compile() {
	ocaml pkg/build.ml \
		native=$(usex ocamlopt true false) \
		native-dynlink=$(usex ocamlopt true false) \
		|| die
}

src_install() {
	# Can't use opam-installer here as it is an opam dep...
	findlib_src_preinst
	local nativelibs=""
	use ocamlopt && nativelibs="$(echo _build/src/cmdliner.cm{x,xa,xs} _build/src/cmdliner.a)"
	ocamlfind install cmdliner _build/pkg/META \
		_build/src/cmdliner.mli _build/src/cmdliner.cm{a,i} ${nativelibs} || die
	dodoc README.md TODO.md CHANGES.md
	use doc && dohtml -r doc/
}
