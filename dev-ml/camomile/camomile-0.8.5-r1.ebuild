# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit findlib eutils

DESCRIPTION="Camomile is a comprehensive Unicode library for ocaml"
HOMEPAGE="https://github.com/yoriyuki/Camomile/wiki"
SRC_URI="https://github.com/yoriyuki/Camomile/releases/download/rel-${PV}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug +ocamlopt"

RDEPEND="
	>=dev-lang/ocaml-3.10.2:=[ocamlopt?]
	dev-ml/camlp4:=
"
DEPEND="${RDEPEND}"

src_configure() {
	econf $(use_enable debug)
}

src_compile() {
	emake -j1 byte unidata unimaps charmap_data locale_data
	if use ocamlopt; then
		emake -j1 opt
	fi
}

src_install() {
	dodir /usr/bin
	findlib_src_install DATADIR="${D}/usr/share" BINDIR="${D}/usr/bin"
}
