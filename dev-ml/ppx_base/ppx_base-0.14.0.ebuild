# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Base set of ppx rewriters"
HOMEPAGE="https://github.com/janestreet/ppx_base"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE="+ocamlopt"

DEPEND="
	dev-ml/ppx_compare:=
	dev-ml/ppx_enumerate:=
	dev-ml/ppx_hash:=
	dev-ml/ppx_js_style:=
	dev-ml/ppx_sexp_conv:=
	dev-ml/ppx_cold:=
	dev-ml/ocaml-migrate-parsetree:=
	dev-ml/ppxlib:=
"
RDEPEND="${DEPEND}"
