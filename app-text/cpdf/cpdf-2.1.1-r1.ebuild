# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit findlib

DESCRIPTION="A command line tool for manipulating PDF files"
HOMEPAGE="http://community.coherentpdf.com/ https://github.com/johnwhitington/cpdf-source/"
SRC_URI="https://github.com/johnwhitington/cpdf-source/archive/v${PV}.tar.gz -> ${P}.tar.gz"

# BSD is only for xmlm.ml
LICENSE="Coherent-Graphics BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=">=dev-lang/ocaml-4:=
	dev-ml/camlpdf:="
DEPEND="${RDEPEND}"

RESTRICT="mirror bindist"

S=${WORKDIR}/${PN}-source-${PV}

src_compile() {
	# parallel make issues
	emake -j1
}

src_install() {
	findlib_src_install

	dobin cpdf
	dodoc Changes README.md

	if use doc ; then
		dodoc cpdfmanual.pdf
		dohtml doc/cpdf/html/*
	fi
}
