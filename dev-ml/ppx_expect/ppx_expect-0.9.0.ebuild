# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit opam

DESCRIPTION="Cram like framework for OCaml"
HOMEPAGE="https://github.com/janestreet/ppx_expect"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-ml/base:=
	dev-ml/ppx_assert:=
	dev-ml/ppx_compare:=
	dev-ml/ppx_core:=
	dev-ml/ppx_custom_printf:=
	dev-ml/ppx_driver:=
	dev-ml/ppx_fields_conv:=
	dev-ml/ppx_here:=
	dev-ml/ppx_inline_test:=
	dev-ml/ppx_metaquot:=
	dev-ml/ppx_sexp_conv:=
	dev-ml/ppx_traverse:=
	dev-ml/ppx_variants_conv:=
	dev-ml/stdio:=
	dev-ml/ocaml-migrate-parsetree:=
	dev-ml/ocaml-re:=
"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND} dev-ml/jbuilder"
