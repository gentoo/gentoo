# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DUNE_PKG_NAME="ssl"
inherit dune

DESCRIPTION="OCaml bindings for OpenSSL"
HOMEPAGE="https://github.com/savonet/ocaml-ssl"
SRC_URI="https://github.com/savonet/ocaml-ssl/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm ~arm64 ~ppc x86"
IUSE="+ocamlopt"

BDEPEND="dev-ml/dune-configurator"
DEPEND="dev-libs/openssl:0=
	>=dev-lang/ocaml-3.10:=[ocamlopt?]"
RDEPEND="${DEPEND}"

src_install() {
	dune_src_install

	dodoc CHANGES README.md
}
