# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit opam

DESCRIPTION="PPX rewriter that generates hash functions from type expressions and definitions"
HOMEPAGE="https://github.com/janestreet/ppx_hash"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="
	dev-ml/base:=
	dev-ml/ppx_compare:=
	dev-ml/ppx_core:=
	dev-ml/ppx_driver:=
	dev-ml/ppx_metaquot:=
	dev-ml/ppx_sexp_conv:=
	dev-ml/ppx_type_conv:=
	dev-ml/ocaml-migrate-parsetree:=
	"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND} dev-ml/jbuilder"
