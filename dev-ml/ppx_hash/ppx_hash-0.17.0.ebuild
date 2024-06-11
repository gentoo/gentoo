# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="PPX rewriter that generates hash functions from type expressions and definitions"
HOMEPAGE="https://github.com/janestreet/ppx_hash"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64"
IUSE="+ocamlopt"

RDEPEND="
	>=dev-lang/ocaml-5
	dev-ml/base:${SLOT}[ocamlopt?]
	dev-ml/ppx_compare:${SLOT}[ocamlopt?]
	dev-ml/ppx_sexp_conv:${SLOT}[ocamlopt?]
	>=dev-ml/ppxlib-0.32.1:=[ocamlopt?]
	dev-ml/ppxlib_jane:${SLOT}[ocamlopt?]
	dev-ml/sexplib0:${SLOT}[ocamlopt?]
"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-ml/dune-3.11"
