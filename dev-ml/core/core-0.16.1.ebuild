# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Jane Street's alternative to the standard library"
HOMEPAGE="https://github.com/janestreet/core"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64 arm arm64 ~ppc ppc64 ~riscv x86"
IUSE="+ocamlopt"

RDEPEND="
	>=dev-lang/ocaml-4.14
	dev-ml/base:${SLOT}
	dev-ml/base_bigstring:${SLOT}
	dev-ml/base_quickcheck:${SLOT}
	dev-ml/bin_prot:${SLOT}
	dev-ml/ppxlib:=
	dev-ml/ppx_bin_prot:=
	dev-ml/ppx_bench:=
	dev-ml/ppx_custom_printf:=
	dev-ml/ppx_disable_unused_warnings:=
	dev-ml/ppx_fields_conv:=
	dev-ml/ppx_fixed_literal:=
	dev-ml/ppx_let:=
	dev-ml/ppx_log:=
	dev-ml/ppx_jane:${SLOT}
	dev-ml/ppx_module_timer:=
	dev-ml/ppx_optional:=
	dev-ml/ppx_pipebang:=
	dev-ml/ppx_sexp_message:${SLOT}
	dev-ml/ppx_sexp_value:=
	dev-ml/ppx_stable:=
	dev-ml/ppx_string:=
	dev-ml/ppx_ignore_instrumentation:=
	dev-ml/typerep:${SLOT}
"
DEPEND="${RDEPEND}"
