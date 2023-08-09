# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit findlib

DESCRIPTION="Declarative definition of command line interfaces for OCaml"
HOMEPAGE="http://erratique.ch/software/cmdliner"
SRC_URI="http://erratique.ch/software/${PN}/releases/${P}.tbz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt"

RDEPEND="
	>=dev-lang/ocaml-4.08.00:=[ocamlopt?]
	dev-ml/result:=
	dev-ml/findlib:=
"
DEPEND="${RDEPEND}
	dev-ml/topkg
	dev-ml/ocamlbuild"

src_compile() {
	emake build-byte
	if use ocamlopt ; then
		emake build-native-dynlink
		emake build-native
	fi
}

src_install() {
	# Can't use opam-installer here as it is an opam dep...
	findlib_src_preinst
	local nativelibs=""
	use ocamlopt && nativelibs="$(echo _build/cmdliner.cm{x,xa,xs} _build/cmdliner.a)"
	ocamlfind install cmdliner pkg/META \
		_build/cmdliner.mli _build/cmdliner.cm{a,i} ${nativelibs} || die
	dodoc README.md CHANGES.md
}
