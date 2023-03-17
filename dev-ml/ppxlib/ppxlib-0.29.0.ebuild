# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

# Note that new "major" versions may change which OCaml version they support
# See:
# https://github.com/ocaml-ppx/ppxlib/issues/243
# https://github.com/ocaml-ppx/ppxlib/issues/232

DESCRIPTION="Base library and tools for ppx rewriters"
HOMEPAGE="https://github.com/ocaml-ppx/ppxlib"
SRC_URI="https://github.com/ocaml-ppx/ppxlib/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ~ppc ~ppc64 ~riscv x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-ml/ocaml-compiler-libs-0.11.0:=
	>=dev-ml/ocaml-migrate-parsetree-2.2.0:=
	dev-ml/sexplib0:=
	dev-ml/stdlib-shims:=
	>=dev-ml/ppx_derivers-1.2.1:=
"
DEPEND="${RDEPEND}
	test? (
		dev-ml/findlib:=
		>=dev-ml/base-0.11.0:=
		dev-ml/cinaps:=
		dev-ml/re:=
		>=dev-ml/stdio-0.11.0:=
	)
"
BDEPEND=">=dev-ml/dune-2.8"
