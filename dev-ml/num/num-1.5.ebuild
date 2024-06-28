# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Not using dune for now, bug #775119
inherit findlib

DESCRIPTION="Library for arbitrary-precision integer and rational arithmetic"
HOMEPAGE="https://github.com/ocaml/num"
SRC_URI="https://github.com/ocaml/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="+ocamlopt"

RDEPEND="dev-lang/ocaml:=[ocamlopt?]"
BDEPEND="${RDEPEND}"
DEPEND="dev-ml/findlib:=[ocamlopt?]"

src_compile() {
	emake CFLAGS="${CFLAGS}" \
		NATDYNLINK="$(usex ocamlopt true false)" \
		NATIVE_COMPILER="$(usex ocamlopt true false)"
}

src_test() {
	# Override needed to not use dune
	emake test
}

src_install() {
	# OCaml generates textrels on 32-bit arches
	if use arm || use ppc || use x86 ; then
		export QA_TEXTRELS='.*'
	fi
	findlib_src_install \
		NATDYNLINK="$(usex ocamlopt true false)" \
		NATIVE_COMPILER="$(usex ocamlopt true false)"

	if has_version ">=dev-ml/findlib-1.9" ; then
		# See bug #803275
		rm "${ED}/usr/$(get_libdir)/ocaml/num-top/META" || die
	fi
}
