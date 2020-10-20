# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DUNE_PKG_NAME="ssl"
inherit dune

DESCRIPTION="OCaml bindings for OpenSSL"
SRC_URI="https://github.com/savonet/ocaml-ssl/archive/${PV}.tar.gz -> ${P}.tar.gz"
HOMEPAGE="https://github.com/savonet/ocaml-ssl"

IUSE="doc +ocamlopt"

DEPEND="dev-libs/openssl:0=
	>=dev-lang/ocaml-3.10:=[ocamlopt?]"
RDEPEND="${DEPEND}"

SLOT="0/${PV}"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~arm ~x86"

src_install() {
	dune_src_install

	dodoc CHANGES README.md

	if use doc; then
		docinto html
		dodoc -r doc/html/*
	fi
}
