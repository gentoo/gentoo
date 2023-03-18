# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="PRNG that can be split into independent streams"
HOMEPAGE="https://github.com/janestreet/splittable_random"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt"

RDEPEND="
	dev-ml/ppx_bench:${SLOT}
	dev-ml/ppx_sexp_message:${SLOT}
"
DEPEND="${RDEPEND}"
