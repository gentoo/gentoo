# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="S-expression pretty-printer"
HOMEPAGE="https://github.com/janestreet/sexp_pretty"
SRC_URI="https://github.com/janestreet/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

DEPEND="
	dev-ml/ppx_base:${SLOT}
	dev-ml/ppx_hash:=
	dev-ml/ppxlib:=
	dev-ml/sexplib:${SLOT}
	dev-ml/re:=
"
RDEPEND="${DEPEND}"
BDEPEND=""
