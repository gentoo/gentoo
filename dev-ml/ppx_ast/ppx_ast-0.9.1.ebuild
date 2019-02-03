# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit opam

DESCRIPTION="AST used in Jane Street ppx rewriters"
HOMEPAGE="https://github.com/janestreet/ppx_ast"
SRC_URI="https://github.com/janestreet/ppx_ast/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="
	dev-ml/ocaml-compiler-libs:=
	dev-ml/ocaml-migrate-parsetree:=
"
RDEPEND="${DEPEND}"
DEPEND="${RDEPEND}
	dev-ml/jbuilder"
