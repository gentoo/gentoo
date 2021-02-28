# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit opam

DESCRIPTION="Feature-full driver for OCaml AST transformers"
HOMEPAGE="https://github.com/janestreet/ppx_driver"
SRC_URI="https://github.com/janestreet/ppx_driver/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~x86"

BDEPEND="dev-ml/jbuilder"
DEPEND="
	dev-ml/ppx_core:=
	dev-ml/stdio:=
	dev-ml/ppx_optcomp:=
	dev-ml/ocaml-migrate-parsetree:=
	dev-ml/ocamlbuild:="
RDEPEND="${DEPEND}"
