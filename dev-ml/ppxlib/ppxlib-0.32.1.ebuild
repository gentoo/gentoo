# Copyright 1999-2024 Gentoo Authors
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
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

# It also works with ocaml >= 4 but tests are to be fixed
RDEPEND="
	>=dev-lang/ocaml-5:=
	>=dev-ml/ocaml-compiler-libs-0.17:=[ocamlopt?]
	dev-ml/ppx_derivers:=[ocamlopt?]
	dev-ml/sexplib0:0/0.17[ocamlopt?]
	dev-ml/stdlib-shims:=[ocamlopt?]
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-ml/dune-3.11
	test? (
		dev-ml/base:0/0.17
		dev-ml/cinaps
		>=dev-ml/findlib-1.9.6[ocamlopt?]
		dev-ml/re
	)
"
