# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Computation with polycyclic groups"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64"

# Circular dependency polycyclic->alnuth->polycyclic. There's a global
# variable called USE_ALNUTH in polycyclic, but setting it to "false"
# doesn't stop polycyclic from using alnuth (why would it?).
RDEPEND="dev-gap/autpgrp"
PDEPEND="dev-gap/alnuth"

# There are likely more problems hiding in the test suite. If we run
# into them, upstream recommends disabling it:
#
#  https://github.com/gap-packages/polycyclic/issues/46
#  https://github.com/gap-packages/polycyclic/issues/89
#
PATCHES=(
	"${FILESDIR}/${P}-hanging-tests.patch"
	"${FILESDIR}/${P}-failing-test.patch"
)

gap-pkg_enable_tests
