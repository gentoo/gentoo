# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Not using dune for now, bug #775119
inherit findlib

DESCRIPTION="Library for arbitrary-precision integer and rational arithmetic"
HOMEPAGE="https://github.com/ocaml/num"
SRC_URI="https://github.com/ocaml/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE="+ocamlopt"

RDEPEND="dev-lang/ocaml:=[ocamlopt?]"
DEPEND="dev-ml/findlib:="

src_compile() {
	emake CFLAGS="${CFLAGS}" NATDYNLINK="$(usex ocamlopt true false)"
}

src_test() {
	# Override needed to not use dune
	emake test
}

src_install() {
	findlib_src_install

	if has_version ">=dev-ml/findlib-1.9" ; then
		# See bug #803275
		rm "${ED}/usr/$(get_libdir)/ocaml/num-top/META" || die
	fi
}
