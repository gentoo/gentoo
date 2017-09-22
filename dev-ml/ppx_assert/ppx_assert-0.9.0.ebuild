# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit opam

DESCRIPTION="Assert-like extension nodes that raise useful errors on failure"
HOMEPAGE="https://github.com/janestreet/ppx_assert"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-ml/base:=
	dev-ml/ppx_compare:=
	dev-ml/ppx_core:=
	dev-ml/ppx_driver:=
	dev-ml/ppx_here:=
	dev-ml/ppx_metaquot:=
	dev-ml/ppx_sexp_conv:=
	dev-ml/ppx_type_conv
	dev-ml/sexplib:=
	dev-ml/ocaml-migrate-parsetree:=
"

RDEPEND="${DEPEND}"
DEPEND="${RDEPEND} dev-ml/jbuilder"
