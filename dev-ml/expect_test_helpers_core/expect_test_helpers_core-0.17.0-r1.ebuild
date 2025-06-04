# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Helpers for writing expectation tests"
HOMEPAGE="https://github.com/janestreet/expect_test_helpers_core"
SRC_URI="https://github.com/janestreet/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64"
IUSE="+ocamlopt"

# Jane Street Minor
JSM=$(ver_cut 1-2)*

RDEPEND="
	>=dev-lang/ocaml-5
	=dev-ml/base-${JSM}:=[ocamlopt?]
	=dev-ml/base_quickcheck-${JSM}:=[ocamlopt?]
	=dev-ml/core-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_jane-${JSM}:=[ocamlopt?]
	dev-ml/re:=[ocamlopt?]
	=dev-ml/sexp_pretty-${JSM}:=[ocamlopt?]
	=dev-ml/stdio-${JSM}:=[ocamlopt?]
"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-ml/dune-3.11"
