# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Base set of ppx rewriters"
HOMEPAGE="https://github.com/janestreet/ppx_base"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt"

DEPEND="
	>=dev-lang/ocaml-4.14
	dev-ml/ppx_cold:${SLOT}
	dev-ml/ppx_globalize:${SLOT}
	dev-ml/ppx_enumerate:${SLOT}
	dev-ml/ppx_hash:${SLOT}
	dev-ml/ppx_sexp_conv:${SLOT}
"
RDEPEND="${DEPEND}"
