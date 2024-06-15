# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit dune toolchain-funcs

DESCRIPTION="Unix-specific portions of Core"
HOMEPAGE="https://github.com/janestreet/core_unix"
SRC_URI="https://github.com/janestreet/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64"
IUSE="+ocamlopt"

RDEPEND="
	>=dev-lang/ocaml-5
	dev-ml/core:${SLOT}[ocamlopt?]
	dev-ml/core_kernel:${SLOT}[ocamlopt?]
	dev-ml/expect_test_helpers_core:${SLOT}[ocamlopt?]
	dev-ml/jane-street-headers:${SLOT}[ocamlopt?]
	dev-ml/jst-config:${SLOT}[ocamlopt?]
	dev-ml/ppx_jane:${SLOT}[ocamlopt?]
	dev-ml/ppx_optcomp:${SLOT}[ocamlopt?]
	dev-ml/sexplib:${SLOT}[ocamlopt?]
	>=dev-ml/spawn-0.15:=[ocamlopt?]
	dev-ml/timezone:${SLOT}[ocamlopt?]
	dev-ml/uopt:${SLOT}[ocamlopt?]
"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-ml/dune-3.11"

PATCHES=( "${FILESDIR}"/${P}-musl.patch )

src_prepare() {
	sed -i \
		-e "s:gcc:$(tc-getCC):" \
		unix_pseudo_terminal/src/discover.sh \
		|| die

	default
}
