# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="PPX rewriter that generates hash functions from type expressions and definitions"
HOMEPAGE="https://github.com/janestreet/ppx_hash"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt"

DEPEND="
	dev-ml/ppx_sexp_conv:${SLOT}
	dev-ml/ppx_compare:${SLOT}
	>=dev-ml/ppxlib-0.23:=
"
RDEPEND="${DEPEND}"
