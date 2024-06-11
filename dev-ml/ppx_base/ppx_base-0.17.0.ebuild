# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Base set of ppx rewriters"
HOMEPAGE="https://github.com/janestreet/ppx_base"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64"
IUSE="+ocamlopt"

RDEPEND="
	>=dev-lang/ocaml-5
	dev-ml/ppx_cold:${SLOT}[ocamlopt?]
	dev-ml/ppx_compare:${SLOT}[ocamlopt?]
	dev-ml/ppx_enumerate:${SLOT}[ocamlopt?]
	dev-ml/ppx_globalize:${SLOT}[ocamlopt?]
	dev-ml/ppx_hash:${SLOT}[ocamlopt?]
	dev-ml/ppx_sexp_conv:${SLOT}[ocamlopt?]
	>=dev-ml/ppxlib-0.32.1:=[ocamlopt?]
"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-ml/dune-3.11"
