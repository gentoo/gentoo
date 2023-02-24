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
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="+ocamlopt"

DEPEND="
	dev-ml/ppxlib:=
	dev-ml/ppx_base:${SLOT}
	dev-ml/ppx_enumerate:=
	dev-ml/ppx_hash:=
	dev-ml/re:=
	dev-ml/sexplib:${SLOT}
"
RDEPEND="${DEPEND}"
BDEPEND=""
