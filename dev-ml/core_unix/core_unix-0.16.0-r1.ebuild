# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit dune toolchain-funcs

DESCRIPTION="Unix-specific portions of Core"
HOMEPAGE="https://github.com/janestreet/core_unix"
SRC_URI="https://github.com/janestreet/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="+ocamlopt"

DEPEND="
	>=dev-lang/ocaml-4.14
	dev-ml/core:=
	dev-ml/core_kernel:${SLOT}
	dev-ml/expect_test_helpers_core:${SLOT}
	dev-ml/ocaml_intrinsics:${SLOT}
	>=dev-ml/spawn-0.15:=
	dev-ml/re:=
	dev-ml/timezone:${SLOT}
"
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=( "${FILESDIR}"/${P}-musl.patch )

src_prepare() {
	sed -i \
		-e "s:gcc:$(tc-getCC):" \
		unix_pseudo_terminal/src/discover.sh \
		|| die

	default
}
