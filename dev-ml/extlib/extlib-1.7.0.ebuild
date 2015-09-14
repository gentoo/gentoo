# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit findlib eutils

DESCRIPTION="Standard library extensions for O'Caml"
HOMEPAGE="https://github.com/ygrek/ocaml-extlib"
SRC_URI="https://github.com/ygrek/ocaml-extlib/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-2.1"
DEPEND="
	>=dev-lang/ocaml-3.10.2:=[ocamlopt?]
	|| ( dev-ml/camlp4:= <dev-lang/ocaml-4.02.0 )
"
RDEPEND="${DEPEND}"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc +ocamlopt"
S="${WORKDIR}/ocaml-${P}"

src_compile() {
	cd src
	emake -j1 all
	if use ocamlopt; then
		emake opt cmxs
	fi

	if use doc; then
		emake doc
	fi
}

src_test() {
	emake -j1 test
}

src_install () {
	findlib_src_install

	# install documentation
	dodoc README

	if use doc; then
		dohtml src/doc/*
	fi
}
