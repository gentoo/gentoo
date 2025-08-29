# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Computation with polycyclic groups"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

# Circular dependency polycyclic->alnuth->polycyclic. There's a global
# variable called USE_ALNUTH in polycyclic, but setting it to "false"
# doesn't stop polycyclic from using alnuth (why would it?).
RDEPEND="dev-gap/autpgrp"
PDEPEND="dev-gap/alnuth"

gap-pkg_enable_tests
