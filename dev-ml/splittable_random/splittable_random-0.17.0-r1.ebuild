# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="PRNG that can be split into independent streams"
HOMEPAGE="https://github.com/janestreet/splittable_random"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~riscv"
IUSE="+ocamlopt"

# Jane Street Minor
JSM=$(ver_cut 1-2)

RDEPEND="
	>=dev-lang/ocaml-5
	=dev-ml/base-${JSM}*:=[ocamlopt?]
	=dev-ml/ppx_assert-${JSM}*:=[ocamlopt?]
	=dev-ml/ppx_bench-${JSM}*:=[ocamlopt?]
	=dev-ml/ppx_inline_test-${JSM}*:=[ocamlopt?]
	=dev-ml/ppx_sexp_message-${JSM}*:=[ocamlopt?]
"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-ml/dune-3.11"
