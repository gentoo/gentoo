# Copyright 1999-2025 Gentoo Authors
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
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt test"
RESTRICT="test" # Test works only with ocaml >= 5

RDEPEND="
	dev-ml/ocaml-compiler-libs:=[ocamlopt?]
	dev-ml/ppx_derivers:=[ocamlopt?]
	dev-ml/sexplib0:=[ocamlopt?]
	dev-ml/stdlib-shims:=[ocamlopt?]
	dev-ml/cmdliner:=[ocamlopt?]
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-ml/dune-3.8
"
