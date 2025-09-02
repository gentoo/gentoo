# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="GAP package for computing with crystallographic groups"
SRC_URI="https://www.math.uni-bielefeld.de/~gaehler/gap/Cryst/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND="dev-gap/polycyclic"

GAP_PKG_EXTRA_INSTALL=( grp )
gap-pkg_enable_tests
