# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Lazily rendering log messages"
HOMEPAGE="https://github.com/janestreet/ppx_log"
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
	=dev-ml/ppx_compare-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_enumerate-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_expect-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_fields_conv-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_here-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_let-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_sexp_conv-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_sexp_message-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_sexp_value-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_string-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_variants_conv-${JSM}:=[ocamlopt?]
	>=dev-ml/ppxlib-0.32.1:=[ocamlopt?]
	=dev-ml/sexplib-${JSM}:=[ocamlopt?]
	=dev-ml/stdio-${JSM}:=[ocamlopt?]
"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-ml/dune-3.11"
