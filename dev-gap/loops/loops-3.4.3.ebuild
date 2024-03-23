# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Computing with quasigroups and loops in GAP"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64"

GAP_PKG_EXTRA_INSTALL=( data )
gap-pkg_enable_tests
