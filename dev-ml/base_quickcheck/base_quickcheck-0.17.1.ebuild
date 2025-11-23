# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Randomized testing framework, designed for compatibility with Base"
HOMEPAGE="https://github.com/janestreet/base_quickcheck"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64"
IUSE="+ocamlopt"

# Jane Street Minor
JSM=$(ver_cut 1-2)*

RDEPEND="
	>=dev-lang/ocaml-5
	=dev-ml/base-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_base-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_compare-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_cold-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_enumerate-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_fields_conv-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_globalize-${JSM}:=[ocamlopt?]
	>=dev-ml/ppx_globalize-0.17.2
	=dev-ml/ppx_hash-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_here-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_let-${JSM}:=[ocamlopt?]
	>=dev-ml/ppx_let-0.17.1
	=dev-ml/ppx_sexp_conv-${JSM}:=[ocamlopt?]
	>=dev-ml/ppx_sexp_conv-0.17.1
	=dev-ml/ppx_sexp_message-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_sexp_value-${JSM}:=[ocamlopt?]
	=dev-ml/ppxlib_jane-${JSM}:=[ocamlopt?]
	>=dev-ml/ppxlib_jane-0.17.4
	=dev-ml/splittable_random-${JSM}:=[ocamlopt?]
	>=dev-ml/ppxlib-0.36.0:=[ocamlopt?]
"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-ml/dune-3.11"
