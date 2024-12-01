# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Collection of standard data structures for GAP"
SRC_URI="https://github.com/gap-packages/datastructures/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

DEPEND="sci-mathematics/gap:="
RDEPEND="${DEPEND}"

DOCS=( CHANGES.md README.md )

gap-pkg_enable_tests
