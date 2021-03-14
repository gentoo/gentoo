# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Standard Jane Street ppx rewriters"
HOMEPAGE="https://github.com/janestreet/ppx_jane"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="amd64 arm ~arm64 ppc ppc64 x86"
IUSE="+ocamlopt"

DEPEND="
	>=dev-ml/base_quickcheck-0.14.0:=
	>=dev-ml/ppx_assert-0.14.0:=
	>=dev-ml/ppx_base-0.14.0:=
	>=dev-ml/ppx_bench-0.14.1:=
	>=dev-ml/ppx_bin_prot-0.14.0:=
	>=dev-ml/ppx_custom_printf-0.14.0:=
	>=dev-ml/ppx_expect-0.14.0:=
	>=dev-ml/ppx_fail-0.14.0:=
	>=dev-ml/ppx_fields_conv-0.14.1:=
	>=dev-ml/ppx_fixed_literal-0.14.0:=
	>=dev-ml/ppx_here-0.14.0:=
	>=dev-ml/ppx_inline_test-0.14.1:=
	>=dev-ml/ppx_let-0.14.0:=
	>=dev-ml/ppx_module_timer-0.14.0:=
	>=dev-ml/ppx_optcomp-0.14.0:=
	>=dev-ml/ppx_optional-0.14.0:=
	>=dev-ml/ppx_pipebang-0.14.0:=
	>=dev-ml/ppx_sexp_message-0.14.0:=
	>=dev-ml/ppx_sexp_value-0.14.0:=
	>=dev-ml/ppx_stable-0.14.1:=
	>=dev-ml/ppx_string-0.14.1:=
	>=dev-ml/ppx_typerep_conv-0.14.1:=
	>=dev-ml/ppx_variants_conv-0.14.1:=
	>=dev-ml/ppxlib-0.18.0:=
"
RDEPEND="${DEPEND}"
