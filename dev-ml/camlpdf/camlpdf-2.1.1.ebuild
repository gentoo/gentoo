# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit findlib eutils

DESCRIPTION="OCaml library for reading, writing, and modifying PDF files"
HOMEPAGE="https://github.com/johnwhitington/camlpdf/"
SRC_URI="https://github.com/johnwhitington/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

# technically LGPL-2.1+ with linking exception
LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

RDEPEND="dev-lang/ocaml:="
DEPEND="${RDEPEND}"

src_prepare() {
	has_version '>=dev-lang/ocaml-4.03.0_beta1' && epatch "${FILESDIR}/ocaml43.patch"
}

src_compile() {
	# parallel make bugs
	emake -j1
}

src_install() {
	findlib_src_install
	dodoc Changes README.md

	if use doc ; then
		dodoc introduction_to_camlpdf.pdf
		dohtml doc/camlpdf/html/*
	fi

	use examples && dodoc -r examples
}
