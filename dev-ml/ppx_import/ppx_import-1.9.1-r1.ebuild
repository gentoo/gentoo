# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="A syntax extension for importing declarations from interface files"
HOMEPAGE="https://github.com/ocaml-ppx/ppx_import/"
SRC_URI="https://github.com/ocaml-ppx/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-ml/ppxlib-0.24:=
	<dev-ml/ppxlib-0.26
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		dev-ml/ounit2
		dev-ml/ppx_deriving
		dev-ml/ppx_sexp_conv
	)
"

PATCHES=( "${FILESDIR}"/${PN}-dune-ounit2.patch )
