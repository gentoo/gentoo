# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Standard Jane Street ppx rewriters"
HOMEPAGE="https://github.com/janestreet/ppx_jane"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm"
IUSE="+ocamlopt"

DEPEND="
	dev-ml/base_quickcheck:=
	dev-ml/ppx_assert:=
	dev-ml/ppx_base:=
	dev-ml/ppx_bench:=
	dev-ml/ppx_bin_prot:=
	dev-ml/ppx_custom_printf:=
	dev-ml/ppx_expect:=
	dev-ml/ppx_fail:=
	dev-ml/ppx_fields_conv:=
	dev-ml/ppx_fixed_literal:=
	dev-ml/ppx_here:=
	dev-ml/ppx_inline_test:=
	dev-ml/ppx_let:=
	dev-ml/ppx_module_timer:=
	dev-ml/ppx_optcomp:=
	dev-ml/ppx_optional:=
	dev-ml/ppx_pipebang:=
	dev-ml/ppx_sexp_message:=
	dev-ml/ppx_sexp_value:=
	dev-ml/ppx_stable:=
	dev-ml/ppx_string:=
	dev-ml/ppx_typerep_conv:=
	dev-ml/ppx_variants_conv:=
	dev-ml/ppxlib:=
"
RDEPEND="${DEPEND}"
