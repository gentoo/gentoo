# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit findlib

DESCRIPTION="An equivalent of the C preprocessor for OCaml programs"
HOMEPAGE="http://mjambon.com/cppo.html"
SRC_URI="https://github.com/mjambon/cppo/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0/${PV}"
LICENSE="BSD"
KEYWORDS="~amd64"

IUSE="examples"

RDEPEND=">=dev-lang/ocaml-3.12:=
	dev-ml/ocamlbuild:="
DEPEND="${RDEPEND}"

src_install() {
	findlib_src_preinst
	mkdir -p "${ED}"/usr/bin
	emake PREFIX="${ED}"/usr install
	dodoc README.md Changes
	if use examples ; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
