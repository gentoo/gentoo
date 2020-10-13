# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Assert-like extension nodes that raise useful errors on failure"
HOMEPAGE="https://github.com/janestreet/ppx_assert"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="+ocamlopt"

DEPEND="
	dev-ml/base:=
	dev-ml/ppx_cold:=
	dev-ml/ppx_compare:=
	dev-ml/ppx_here:=
	dev-ml/ppx_sexp_conv:=
	dev-ml/ppxlib:=
		dev-ml/ocaml-migrate-parsetree:=
			dev-ml/result:=
"
RDEPEND="${DEPEND}"
