# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Syntax extension for writing in-line benchmarks in ocaml code"
HOMEPAGE="https://github.com/janestreet/ppx_bench"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm"
IUSE="+ocamlopt"

DEPEND="
	dev-ml/ppx_inline_test:=
	dev-ml/ppxlib:=
		dev-ml/stdio:=
		dev-ml/ocaml-migrate-parsetree:=
			dev-ml/result:=
"
RDEPEND="${DEPEND}"
