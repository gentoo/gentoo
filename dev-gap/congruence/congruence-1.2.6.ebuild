# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Congruence subgroups of SL(2,ZZ) for GAP"
SRC_URI="https://github.com/gap-packages/congruence/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

gap-pkg_enable_tests
