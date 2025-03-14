# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=${PN/-stub/}
MY_P=${P/-stub/}

DUNE_PKG_NAME="gettext-stub"

inherit dune

DESCRIPTION="Support for internationalization of OCaml programs using native gettext library"
HOMEPAGE="https://github.com/gildor478/ocaml-gettext"
SRC_URI="https://github.com/gildor478/ocaml-gettext/archive/v${PV}.tar.gz
	-> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc64"
IUSE="+ocamlopt test"
RESTRICT="test"  # Tests fail.

RDEPEND="
	~dev-ml/ocaml-gettext-${PV}:=[ocamlopt?]
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-ml/dune-3.17
	dev-ml/cppo
	dev-ml/dune-configurator
	test? (
		dev-ml/ounit2[ocamlopt=]
		dev-ml/seq[ocamlopt=]
	)
"

src_compile() {
	dune-compile ${DUNE_PKG_NAME}
}

src_test() {
	dune-test ${DUNE_PKG_NAME}
}
