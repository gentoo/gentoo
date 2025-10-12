# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit findlib

DESCRIPTION="Non-blocking streaming Unicode codec for OCaml"
HOMEPAGE="https://erratique.ch/software/uutf"
SRC_URI="https://erratique.ch/software/uutf/releases/${P}.tbz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="doc +ocamlopt"
RESTRICT="test"

RDEPEND="dev-ml/uchar:="
DEPEND="${RDEPEND}"
BDEPEND="dev-ml/ocamlbuild
	dev-ml/topkg"

DOCS=( CHANGES.md README.md )

src_compile() {
	ocaml pkg/pkg.ml build || die
}

src_install() {
	# Can't use opam-installer here as it is an opam dep...
	findlib_src_preinst
	local nativelibs=""

	use ocamlopt &&
		nativelibs="$(echo _build/src/uutf.cm{x,xa,xs} _build/src/uutf.a)"
	ocamlfind install uutf _build/pkg/META _build/src/uutf.mli _build/src/uutf.cm{a,i} ${nativelibs} || die

	einstalldocs
	if use doc ; then
		docinto html
		dodoc -r doc/*
	fi
}
