# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Jane Street's alternative to the standard library"
HOMEPAGE="https://github.com/janestreet/core"
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
	=dev-ml/base_bigstring-${JSM}:=[ocamlopt?]
	=dev-ml/base_quickcheck-${JSM}:=[ocamlopt?]
	=dev-ml/bin_prot-${JSM}:=[ocamlopt?]
	=dev-ml/fieldslib-${JSM}:=[ocamlopt?]
	=dev-ml/jane-street-headers-${JSM}:=[ocamlopt?]
	=dev-ml/jst-config-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_assert-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_base-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_diff-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_hash-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_inline_test-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_jane-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_optcomp-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_sexp_conv-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_sexp_message-${JSM}:=[ocamlopt?]
	=dev-ml/sexplib-${JSM}:=[ocamlopt?]
	=dev-ml/splittable_random-${JSM}:=[ocamlopt?]
	=dev-ml/stdio-${JSM}:=[ocamlopt?]
	=dev-ml/time_now-${JSM}:=[ocamlopt?]
	=dev-ml/typerep-${JSM}:=[ocamlopt?]
	=dev-ml/variantslib-${JSM}:=[ocamlopt?]
"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-ml/dune-3.11"
