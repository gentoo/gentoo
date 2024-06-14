# Copyright 2023-2024 Gentoo Authors
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

RDEPEND="
	>=dev-lang/ocaml-5
	dev-ml/base:${SLOT}[ocamlopt?]
	dev-ml/ppx_compare:${SLOT}[ocamlopt?]
	dev-ml/ppx_enumerate:${SLOT}[ocamlopt?]
	dev-ml/ppx_expect:${SLOT}[ocamlopt?]
	dev-ml/ppx_fields_conv:${SLOT}[ocamlopt?]
	dev-ml/ppx_here:${SLOT}[ocamlopt?]
	dev-ml/ppx_let:${SLOT}[ocamlopt?]
	dev-ml/ppx_sexp_conv:${SLOT}[ocamlopt?]
	dev-ml/ppx_sexp_message:${SLOT}[ocamlopt?]
	dev-ml/ppx_sexp_value:${SLOT}[ocamlopt?]
	dev-ml/ppx_string:${SLOT}[ocamlopt?]
	dev-ml/ppx_variants_conv:${SLOT}[ocamlopt?]
	>=dev-ml/ppxlib-0.32.1:=[ocamlopt?]
	dev-ml/sexplib:${SLOT}[ocamlopt?]
	dev-ml/stdio:${SLOT}[ocamlopt?]
"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-ml/dune-3.11"
