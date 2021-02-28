# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Take TDD to a new level with py.test and testmon"
HOMEPAGE="https://github.com/tarpas/pytest-testmon"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# Tests are broken for version 1.0.3
# https://github.com/tarpas/pytest-testmon/issues/158
RESTRICT="test"

RDEPEND="
	dev-python/coverage[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]"
BDEPEND="test? ( dev-python/unittest-mixins[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest
