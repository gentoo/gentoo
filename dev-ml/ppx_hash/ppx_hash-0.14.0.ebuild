# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="PPX rewriter that generates hash functions from type expressions and definitions"
HOMEPAGE="https://github.com/janestreet/ppx_hash"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE="+ocamlopt"

DEPEND="
	dev-ml/base:=
	>=dev-ml/ppx_compare-0.10.0:=
	dev-ml/ppx_sexp_conv:=
	dev-ml/ocaml-migrate-parsetree:=
		dev-ml/result:=
	dev-ml/ppxlib:=
"
RDEPEND="${DEPEND}"
