# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit findlib

DESCRIPTION="Non-blocking streaming JSON codec for OCaml"
HOMEPAGE="http://erratique.ch/software/jsonm"
SRC_URI="http://erratique.ch/software/jsonm/releases/${P}.tbz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm"
IUSE=""

RDEPEND=">=dev-ml/uutf-1.0.0:=
	dev-lang/ocaml:=
	dev-ml/uchar:="
DEPEND="${RDEPEND}
	dev-ml/topkg
	dev-ml/ocamlbuild
	dev-ml/findlib"

DOCS=( CHANGES README )

src_compile() {
	ocaml pkg/pkg.ml build || die
}

src_install() {
	# Can't use opam-installer here as it is an opam dep...
	findlib_src_preinst
	local nativelibs="$(echo _build/src/${PN}.cm{x,xa,xs,ti} _build/src/${PN}.a)"
	ocamlfind install ${PN} _build/pkg/META _build/src/${PN}.mli _build/src/${PN}.cm{a,i} ${nativelibs} || die
	newbin _build/test/jsontrip.native jsontrip
	dodoc CHANGES.md TODO.md README.md
}
