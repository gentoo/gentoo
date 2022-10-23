# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="String type based on Bigarray, for use in I/O and C-bindings"
HOMEPAGE="https://github.com/janestreet/base_bigstring"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ~ppc ppc64 ~riscv x86"
IUSE="+ocamlopt"

DEPEND="
	>=dev-lang/ocaml-4.08.0:=[ocamlopt=]
	dev-ml/base:=
	dev-ml/base_quickcheck:=
	dev-ml/ppx_bench:=
	dev-ml/ppx_bin_prot:=
	=dev-ml/ppx_compare-0.14*:=
	dev-ml/ppx_custom_printf:=
	dev-ml/ppx_expect:=
	dev-ml/ppx_fields_conv:=
	dev-ml/ppx_fixed_literal:=
	dev-ml/ppx_jane:=
	dev-ml/ppx_let:=
	dev-ml/ppx_module_timer:=
	dev-ml/ppx_optional:=
	dev-ml/ppx_pipebang:=
	dev-ml/ppx_sexp_message:=
	dev-ml/ppx_sexp_value:=
	dev-ml/ppx_stable:=
	dev-ml/ppx_string:=
	dev-ml/ppx_typerep_conv:=
	dev-ml/ppx_variants_conv:=
	dev-ml/sexplib0:=
"
RDEPEND="${DEPEND}"
