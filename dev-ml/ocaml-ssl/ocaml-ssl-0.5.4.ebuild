# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit findlib eutils

IUSE="doc"

DESCRIPTION="OCaml bindings for OpenSSL"
SRC_URI="https://github.com/savonet/ocaml-ssl/releases/download/${PV}/${P}.tar.gz"
HOMEPAGE="https://github.com/savonet/ocaml-ssl"

DEPEND="dev-libs/openssl:0=
	>=dev-lang/ocaml-3.10:="
RDEPEND="${DEPEND}"

SLOT="0/${PV}"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~arm ~ppc ~x86"

src_compile() {
	emake -j1
}

src_install() {
	findlib_src_preinst
	emake install

	if use doc; then
		dohtml -r doc/html/*
	fi
	dodoc CHANGES README.md
}
