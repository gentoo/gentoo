# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8,9} )
inherit distutils-r1

DESCRIPTION="Generic testsuite framework in Python"
HOMEPAGE="https://www.adacore.com/"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="!test? ( test )"

RDEPEND="dev-ada/e3-core[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND=""

distutils_enable_tests --install pytest
