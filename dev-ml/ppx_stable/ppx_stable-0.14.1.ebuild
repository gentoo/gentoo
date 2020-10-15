# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Stable types conversions generator"
HOMEPAGE="https://github.com/janestreet/ppx_stable"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm"
IUSE="+ocamlopt"

DEPEND="
	dev-ml/base:=
	dev-ml/ppxlib:=
		dev-ml/ocaml-migrate-parsetree:=
			dev-ml/result:=
"
RDEPEND="${DEPEND}"
