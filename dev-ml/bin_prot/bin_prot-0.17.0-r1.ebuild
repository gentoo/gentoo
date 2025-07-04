# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Binary protocol generator"
HOMEPAGE="https://github.com/janestreet/bin_prot"
SRC_URI="https://github.com/janestreet/bin_prot/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
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
	=dev-ml/ppx_custom_printf-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_fields_conv-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_optcomp-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_sexp_conv-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_stable_witness-${JSM}:=[ocamlopt?]
	=dev-ml/ppx_variants_conv-${JSM}:=[ocamlopt?]
"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-ml/dune-3.11"
