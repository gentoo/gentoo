# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Using "--for-release-of-packages" skips the regeneration of "unicode.ml" file
# (using curl), see "src_compile" and "src_test" and "dune-release".
DUNE_PKG_NAME=${PN}

inherit dune

DESCRIPTION="An OCaml lexer generator for Unicode"
HOMEPAGE="https://github.com/ocaml-community/sedlex/"
SRC_URI="https://github.com/ocaml-community/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-ml/gen:=
	>=dev-ml/ppxlib-0.26:=
"
RDEPEND="${DEPEND}"
BDEPEND="test? ( dev-ml/ppx_expect )"

src_compile() {
	dune-compile ${DUNE_PKG_NAME}
}

src_test() {
	dune-test ${DUNE_PKG_NAME}
}
