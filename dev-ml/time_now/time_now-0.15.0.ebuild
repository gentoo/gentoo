# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Reports the current time"
HOMEPAGE="https://github.com/janestreet/time_now"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt"

DEPEND="
	dev-ml/jane-street-headers:${SLOT}
	dev-ml/jst-config:${SLOT}
	dev-ml/ppx_base:${SLOT}
	dev-ml/ppx_optcomp:${SLOT}
"
RDEPEND="${DEPEND}"
