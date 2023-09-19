# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit dune

DESCRIPTION="Unix-specific portions of Core"
HOMEPAGE="https://github.com/janestreet/core_unix"
SRC_URI="https://github.com/janestreet/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

DEPEND="
	dev-ml/core_kernel:${SLOT}
	dev-ml/expect_test_helpers_core:${SLOT}
	dev-ml/ocaml_intrinsics:${SLOT}
	dev-ml/timezone:${SLOT}
	dev-ml/spawn:${SLOT}
"
RDEPEND="${DEPEND}"
BDEPEND=""
