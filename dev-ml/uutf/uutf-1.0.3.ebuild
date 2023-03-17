# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit findlib

DESCRIPTION="Non-blocking streaming Unicode codec for OCaml"
HOMEPAGE="https://erratique.ch/software/uutf"
SRC_URI="https://erratique.ch/software/uutf/releases/${P}.tbz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ~ppc ~ppc64 ~riscv x86"
IUSE="doc utftrip +ocamlopt test"
RESTRICT="!test? ( test )"
REQUIRED_USE="utftrip? ( ocamlopt )"

RDEPEND=">=dev-lang/ocaml-3.12:=[ocamlopt?]
	dev-ml/uchar:=
	utftrip? ( dev-ml/cmdliner:=[ocamlopt?] )"
DEPEND="${RDEPEND}"
BDEPEND="dev-ml/ocamlbuild
	dev-ml/topkg
	test? ( dev-ml/cmdliner[ocamlopt?] )"

DOCS=( CHANGES.md README.md )

src_compile() {
	ocaml pkg/pkg.ml build \
		--with-cmdliner "$(usex utftrip true false)" \
		--tests "$(usex test true false)" \
		|| die
}

src_test() {
	if use ocamlopt ; then
		pushd _build/test || die
		./test.native || die
		# Rebuild to avoid mismatches between installed files, bug #604674
		popd || die
		ocaml pkg/pkg.ml build \
			--with-cmdliner "$(usex utftrip true false)" \
			|| die
	else
		ewarn "Sorry, ${PN} tests require native support (ocamlopt)"
	fi
}

src_install() {
	# Can't use opam-installer here as it is an opam dep...
	findlib_src_preinst
	local nativelibs=""

	use ocamlopt &&
		nativelibs="$(echo _build/src/uutf.cm{x,xa,xs} _build/src/uutf.a)"
	ocamlfind install uutf _build/pkg/META _build/src/uutf.mli _build/src/uutf.cm{a,i} ${nativelibs} || die
	use utftrip &&
		newbin _build/test/utftrip.$(usex ocamlopt native byte) utftrip

	einstalldocs
	if use doc ; then
		docinto html
		dodoc -r doc/*
	fi
}
