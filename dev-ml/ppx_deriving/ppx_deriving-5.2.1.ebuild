# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Type-driven code generation for OCaml"
HOMEPAGE="https://github.com/ocaml-ppx/ppx_deriving"
SRC_URI="https://github.com/ocaml-ppx/ppx_deriving/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-ml/ppx_tools:=
	dev-ml/ocaml-migrate-parsetree:=
	dev-ml/ppx_derivers:=
	>=dev-ml/ppxlib-0.20.0:=
	dev-ml/findlib:=
	dev-ml/result:=
	dev-ml/sexplib0:=
"
RDEPEND="${DEPEND}"
DEPEND="${RDEPEND}
	dev-ml/cppo
	test? ( dev-ml/ounit2 )"
