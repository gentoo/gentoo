# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="A ppx rewriter that inlines reverse application operators |> and |!"
HOMEPAGE="https://github.com/janestreet/ppx_pipebang"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE="+ocamlopt"

DEPEND="
	dev-ml/ppxlib:=
		dev-ml/ocaml-migrate-parsetree:=
			dev-ml/result:=
	dev-ml/base:=
"
RDEPEND="${DEPEND}"
