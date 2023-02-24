# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit dune

DESCRIPTION="Lazily rendering log messages"
HOMEPAGE="https://github.com/janestreet/ppx_log"
SRC_URI="https://github.com/janestreet/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="+ocamlopt"

DEPEND="
	dev-ml/ppx_sexp_message:${SLOT}
	dev-ml/sexplib:${SLOT}
	>=dev-ml/ppxlib-0.23.0:=
"
RDEPEND="${DEPEND}"
BDEPEND=""
