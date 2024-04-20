# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DUNE_PKG_NAME=ssl

inherit dune

DESCRIPTION="OCaml bindings for OpenSSL"
HOMEPAGE="https://github.com/savonet/ocaml-ssl"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/savonet/${PN}.git"
else
	SRC_URI="https://github.com/savonet/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/openssl:0=
	dev-lang/ocaml
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-ml/dune-configurator
	test? ( dev-ml/alcotest )
"

DOCS=( CHANGES.md README.md )

src_install() {
	dune_src_install

	einstalldocs
}
