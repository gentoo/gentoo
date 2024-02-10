# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

MY_PN="FactInt"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Advanced Methods for Factoring Integers"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${MY_PN}/releases/download/v${PV}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
KEYWORDS="~amd64"

GAP_PKG_EXTRA_INSTALL=( tables )
gap-pkg_enable_tests
