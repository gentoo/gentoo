# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Algebraic number theory and an interface to PARI/GP"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

# Circular dependency alnuth->polycyclic->alnuth...
RDEPEND="dev-gap/polycyclic
	sci-mathematics/pari"
BDEPEND="test? ( dev-gap/radiroot )"

GAP_PKG_HTML_DOCDIR="htm"

# The "exam" directory contains examples... but they're loaded by
# read.g, and actually used by dev-gap/polenta!
GAP_PKG_EXTRA_INSTALL=( exam gp )

gap-pkg_enable_tests
