# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="System-independent part of Core"
HOMEPAGE="https://github.com/janestreet/core_kernel"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="+ocamlopt"

# Wants quickcheck_deprecated for now
RESTRICT="test"

RDEPEND="
	dev-ml/core:${SLOT}
	dev-ml/int_repr:${SLOT}
"
DEPEND="${RDEPEND}"
