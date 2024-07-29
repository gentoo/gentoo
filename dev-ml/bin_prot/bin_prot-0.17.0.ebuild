# Copyright 1999-2024 Gentoo Authors
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

RDEPEND="
	>=dev-lang/ocaml-5
	dev-ml/base:${SLOT}[ocamlopt?]
	dev-ml/ppx_base:${SLOT}[ocamlopt?]
	dev-ml/ppx_compare:${SLOT}[ocamlopt?]
	dev-ml/ppx_custom_printf:${SLOT}[ocamlopt?]
	dev-ml/ppx_fields_conv:${SLOT}[ocamlopt?]
	dev-ml/ppx_optcomp:${SLOT}[ocamlopt?]
	dev-ml/ppx_sexp_conv:${SLOT}[ocamlopt?]
	dev-ml/ppx_stable_witness:${SLOT}[ocamlopt?]
	dev-ml/ppx_variants_conv:${SLOT}[ocamlopt?]
"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-ml/dune-3.11"
