# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="GAP interface to sci-mathematics/polymake"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

# Tests fail: https://github.com/gap-packages/polymaking/issues/18
RESTRICT=test

RDEPEND="sci-mathematics/polymake"

DOCS=( CHANGES.md README.md )

gap-pkg_enable_tests
