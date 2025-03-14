# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DUNE_PKG_NAME="gettext"
inherit dune

DESCRIPTION="Provides support for internationalization of OCaml program"
HOMEPAGE="https://github.com/gildor478/ocaml-gettext"
SRC_URI="https://github.com/gildor478/ocaml-gettext/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="+ocamlopt test"
RESTRICT="test"  # Tests fail

BDEPEND="
	>=dev-ml/dune-3.17
	dev-ml/cppo
	dev-ml/dune-configurator
"

RDEPEND="
	dev-ml/ocaml-fileutils:=[ocamlopt?]
	dev-ml/dune-site:=[ocamlopt?]
	sys-devel/gettext
"
DEPEND="
	${RDEPEND}
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
