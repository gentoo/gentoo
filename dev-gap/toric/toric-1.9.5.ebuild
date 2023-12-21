# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

MY_PN="Toric"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="GAP package for computing with toric varieties"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/${MY_P}"

gap-pkg_enable_tests
