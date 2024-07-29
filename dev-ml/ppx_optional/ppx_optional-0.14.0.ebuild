# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Pattern matching on flat options"
HOMEPAGE="https://github.com/janestreet/ppx_optional"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ~ppc ppc64 ~riscv x86"
IUSE="+ocamlopt"

DEPEND="
	dev-ml/base:=
	dev-ml/ppxlib:=
	dev-ml/ocaml-migrate-parsetree:=
	dev-ml/result:=
	dev-ml/sexplib0:=
"
RDEPEND="${DEPEND}"
