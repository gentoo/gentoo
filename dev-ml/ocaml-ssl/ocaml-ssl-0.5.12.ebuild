# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DUNE_PKG_NAME=ssl

inherit dune

DESCRIPTION="OCaml bindings for OpenSSL"
HOMEPAGE="https://github.com/savonet/ocaml-ssl"
SRC_URI="https://github.com/savonet/ocaml-ssl/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

DEPEND="dev-libs/openssl:0=
	>=dev-lang/ocaml-3.10:=[ocamlopt?]"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-ml/dune-configurator
	test? ( dev-ml/alcotest )
"

src_install() {
	dune_src_install

	dodoc CHANGES.md README.md
}
