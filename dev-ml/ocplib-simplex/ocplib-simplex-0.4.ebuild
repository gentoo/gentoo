# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools findlib

DESCRIPTION="A library implementing a simplex algorithm"
HOMEPAGE="https://github.com/OCamlPro-Iguernlala/ocplib-simplex"
SRC_URI="https://github.com/OCamlPro-Iguernlala/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0"
KEYWORDS="amd64"

DOCS=( CHANGES.md README.md extra/simplex_invariants.txt extra/TODO.txt )

PATCHES=(
	"${FILESDIR}"/${P}-flags.patch
)

QA_FLAGS_IGNORED=(
	/usr/lib64/ocaml/ocplib-simplex/ocplibSimplex.cmxs
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	sed -i -e "s:configure.in:configure.ac:g" \
		Makefile.in || die
	eautoreconf
}

src_install() {
	findlib_src_install LIBDIR="${D}"/usr/"$(get_libdir)"/ocaml
}
