# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Free Group Algorithms (FGA) for GAP"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64"

gap-pkg_enable_tests
