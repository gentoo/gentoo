# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Ppx rewriter that records top-level module startup times"
HOMEPAGE="https://github.com/janestreet/ppx_module_timer"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt"

DEPEND="
	dev-ml/time_now:${SLOT}
	>=dev-ml/ppxlib-0.23.0:=
"
RDEPEND="${DEPEND}"
