# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Standard Jane Street ppx rewriters"
HOMEPAGE="https://github.com/janestreet/ppx_jane"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64"
IUSE="+ocamlopt"

RDEPEND="
	>=dev-lang/ocaml-5
	dev-ml/base_quickcheck:${SLOT}[ocamlopt?]
	dev-ml/ppx_assert:${SLOT}[ocamlopt?]
	dev-ml/ppx_base:${SLOT}[ocamlopt?]
	dev-ml/ppx_bench:${SLOT}[ocamlopt?]
	dev-ml/ppx_bin_prot:${SLOT}[ocamlopt?]
	dev-ml/ppx_custom_printf:=[ocamlopt?]
	dev-ml/ppx_disable_unused_warnings:${SLOT}[ocamlopt?]
	dev-ml/ppx_expect:${SLOT}[ocamlopt?]
	dev-ml/ppx_fields_conv:${SLOT}[ocamlopt?]
	dev-ml/ppx_fixed_literal:${SLOT}[ocamlopt?]
	dev-ml/ppx_here:${SLOT}[ocamlopt?]
	dev-ml/ppx_ignore_instrumentation:${SLOT}[ocamlopt?]
	dev-ml/ppx_inline_test:${SLOT}[ocamlopt?]
	dev-ml/ppx_let:${SLOT}[ocamlopt?]
	dev-ml/ppx_log:${SLOT}[ocamlopt?]
	dev-ml/ppx_module_timer:${SLOT}[ocamlopt?]
	dev-ml/ppx_optional:${SLOT}[ocamlopt?]
	dev-ml/ppx_pipebang:${SLOT}[ocamlopt?]
	dev-ml/ppx_sexp_message:${SLOT}[ocamlopt?]
	dev-ml/ppx_sexp_value:${SLOT}[ocamlopt?]
	dev-ml/ppx_stable:${SLOT}[ocamlopt?]
	dev-ml/ppx_stable_witness:${SLOT}[ocamlopt?]
	dev-ml/ppx_string:${SLOT}
	dev-ml/ppx_string_conv:${SLOT}
	dev-ml/ppx_tydi:${SLOT}
	dev-ml/ppx_typerep_conv:${SLOT}
	dev-ml/ppx_variants_conv:${SLOT}
	>=dev-ml/ppxlib-0.32.1:=[ocamlopt?]
"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-ml/dune-3.11"
