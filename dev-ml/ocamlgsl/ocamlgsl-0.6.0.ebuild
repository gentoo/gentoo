# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit base findlib

DESCRIPTION="OCaml bindings for the GSL library"
HOMEPAGE="http://oandrieu.nerim.net/ocaml/gsl/"
SRC_URI="http://oandrieu.nerim.net/ocaml/gsl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/${PV}"
KEYWORDS="amd64 ~ppc x86"
IUSE="doc test"

RDEPEND=">=dev-lang/ocaml-3.10:=
	  sci-libs/gsl
	  !dev-ml/gsl-ocaml"
DEPEND="${RDEPEND}
	  test? ( dev-ml/fort )"

PATCHES=( "${FILESDIR}/${P}-ocaml311.patch" )

src_compile() {
	emake CFLAGS="${CFLAGS}"
}

src_install() {
	findlib_src_preinst
	emake install-findlib

	dodoc README NEWS NOTES
	doinfo *.info*
	if use doc; then
		dohtml doc/*
	fi
}
