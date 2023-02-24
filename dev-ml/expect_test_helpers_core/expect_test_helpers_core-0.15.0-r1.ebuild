# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Helpers for writing expectation tests"
HOMEPAGE="https://github.com/janestreet/expect_test_helpers_core"
SRC_URI="https://github.com/janestreet/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="+ocamlopt"

DEPEND="
	dev-ml/base:${SLOT}
	dev-ml/core:${SLOT}
	dev-ml/ppx_jane:${SLOT}
	dev-ml/stdio:${SLOT}
	dev-ml/sexp_pretty:${SLOT}
"
RDEPEND="${DEPEND}"
BDEPEND=""
