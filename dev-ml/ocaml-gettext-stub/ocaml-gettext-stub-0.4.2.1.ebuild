# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=${PN/-stub/}
MY_P=${P/-stub/}

DUNE_PKG_NAME="gettext-stub"

inherit dune
comId=d566551bc2e2f5e6e61d24e05d314ff57eaea6bf

DESCRIPTION="Support for internationalization of OCaml programs using native gettext library"
HOMEPAGE="https://github.com/gildor478/ocaml-gettext"
SRC_URI="https://github.com/gildor478/ocaml-gettext/archive/${comId}.tar.gz
	-> ${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_PN}-${comId}

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc64"
IUSE="+ocamlopt test"
RESTRICT="test"  # Tests fail.

RDEPEND="
	>=dev-lang/ocaml-4.14.0:=[ocamlopt?]
	~dev-ml/ocaml-gettext-${PV}:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-ml/dune-configurator-3.17.0
	test? (
		>=dev-ml/ocaml-fileutils-0.6.6
		dev-ml/ounit2[ocamlopt=]
	)
"

src_compile() {
	dune-compile ${DUNE_PKG_NAME}
}
