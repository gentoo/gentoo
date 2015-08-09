# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit findlib eutils

IUSE="doc"

DESCRIPTION="OCaml bindings for OpenSSL"
SRC_URI="mirror://sourceforge/savonet/${P}.tar.gz"
HOMEPAGE="http://savonet.sourceforge.net"

DEPEND="dev-libs/openssl[-bindist]
	>=dev-lang/ocaml-3.10:="
RDEPEND="${DEPEND}"

SLOT="0/${PV}"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"

src_compile() {
	emake -j1
}

src_install() {
	findlib_src_preinst
	emake install

	if use doc; then
		dohtml -r doc/html/*
	fi
	dodoc CHANGES README
}
