# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Micro-benchmarking library for OCaml"
HOMEPAGE="https://github.com/janestreet/core_bench"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="+ocamlopt"

DEPEND="
	>=dev-lang/ocaml-4.14
	dev-ml/core:${SLOT}
	dev-ml/core_kernel:${SLOT}
	dev-ml/core_unix:${SLOT}
	dev-ml/ppx_compare:${SLOT}
	dev-ml/ppx_jane:${SLOT}
	dev-ml/ppx_let:${SLOT}
	dev-ml/textutils:${SLOT}
"
RDEPEND="${DEPEND}"
