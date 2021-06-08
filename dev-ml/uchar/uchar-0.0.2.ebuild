# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit findlib

DESCRIPTION="Uchar compatibility library"
HOMEPAGE="https://github.com/ocaml/uchar"
SRC_URI="https://github.com/ocaml/uchar/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ppc ppc64 x86"
IUSE="+ocamlopt"

RDEPEND=">=dev-lang/ocaml-4.03:="
DEPEND="${RDEPEND} dev-ml/ocamlbuild"

# This is mostly a compat wrapper for older ocaml versions we don't support. No
# need to test it, plus it fails when installing for the first time:
# https://bugs.gentoo.org/show_bug.cgi?id=624144
RESTRICT="test"

src_compile() {
	ocaml pkg/build.ml \
		"native=$(usex ocamlopt true false)" \
		"native-dynlink=$(usex ocamlopt true false)" || die
}

src_test() {
	ocamlbuild -X src -use-ocamlfind -pkg uchar test/testpkg.native || die
}

src_install() {
	# Can't use opam-installer here as it is an opam dep...
	findlib_src_preinst
	mv _build/pkg/META{.empty,} || die
	ocamlfind install ${PN} _build/pkg/META || die
	dodoc README.md CHANGES.md
}
