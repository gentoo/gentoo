# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="A ppx rewriter for easy construction of s-expressions"
HOMEPAGE="https://github.com/janestreet/ppx_sexp_message"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE="+ocamlopt"

DEPEND="
	dev-ml/base:=
	dev-ml/ppx_here:=
	dev-ml/ppx_sexp_conv:=
	dev-ml/ocaml-migrate-parsetree:=
		dev-ml/result:=
	>=dev-ml/ppxlib-0.18.0:=
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-ppxlib-0.18.0.patch )
