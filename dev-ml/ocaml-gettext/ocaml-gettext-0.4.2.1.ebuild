# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DUNE_PKG_NAME="gettext"
inherit dune
comId=d566551bc2e2f5e6e61d24e05d314ff57eaea6bf

DESCRIPTION="Provides support for internationalization of OCaml program"
HOMEPAGE="https://github.com/gildor478/ocaml-gettext"
SRC_URI="https://github.com/gildor478/ocaml-gettext/archive/${comId}.tar.gz
	-> ${P}.tar.gz"

S="${WORKDIR}"/${PN}-${comId}

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="+ocamlopt test"
RESTRICT="test"  # Tests fail

RDEPEND="
	>=dev-lang/ocaml-4.14.0:=[ocamlopt?]
	dev-ml/base:=
	>=dev-ml/ocaml-fileutils-0.6.6:=[ocamlopt=]
	sys-devel/gettext
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-ml/cppo-1.8.0
	test? ( dev-ml/ounit2[ocamlopt=] )
"

src_compile() {
	dune-compile ${DUNE_PKG_NAME}
}
