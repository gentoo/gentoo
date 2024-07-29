# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="System-independent part of Core"
HOMEPAGE="https://github.com/janestreet/core_kernel"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64 arm arm64 ~ppc ppc64 ~riscv x86"
IUSE="+ocamlopt"

# Wants quickcheck_deprecated for now
RESTRICT="test"

RDEPEND="
	>=dev-lang/ocaml-4.14
	dev-ml/base_quickcheck:=
	dev-ml/core:${SLOT}
	dev-ml/int_repr:${SLOT}
	dev-ml/ppx_assert:=
	dev-ml/ppx_bench:=
	dev-ml/ppx_bin_prot:=
	dev-ml/ppx_cold:=
	dev-ml/ppx_compare:=
	dev-ml/ppx_custom_printf:=
	dev-ml/ppx_disable_unused_warnings:=
	dev-ml/ppx_enumerate:=
	dev-ml/ppx_expect:=
	dev-ml/ppx_fields_conv:=
	dev-ml/ppx_fixed_literal:=
	dev-ml/ppx_globalize:=
	dev-ml/ppx_hash:=
	dev-ml/ppx_here:=
	dev-ml/ppx_ignore_instrumentation:=
	dev-ml/ppx_inline_test:=
	dev-ml/ppx_let:=
	dev-ml/ppx_log:=
	dev-ml/ppx_module_timer:=
	dev-ml/ppx_optcomp:${SLOT}
	dev-ml/ppx_optional:=
	dev-ml/ppx_pipebang:=
	dev-ml/ppx_sexp_conv:=
	dev-ml/ppx_sexp_message:=
	dev-ml/ppx_sexp_value:=
	dev-ml/ppx_stable:=
	dev-ml/ppx_stable_witness:=
	dev-ml/ppx_string:=
	dev-ml/ppx_tydi:=
	dev-ml/ppx_typerep_conv:=
	dev-ml/ppx_variants_conv:=
	dev-ml/ppxlib:=
"
DEPEND="${RDEPEND}"
