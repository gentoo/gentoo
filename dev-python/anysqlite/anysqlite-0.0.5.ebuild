# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1

DESCRIPTION="sqlite3 for asyncio and trio"
HOMEPAGE="
	https://github.com/karpetrosyan/anysqlite/
	https://pypi.org/project/anysqlite/
"
SRC_URI="
	https://github.com/karpetrosyan/anysqlite/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/anyio-3.4.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-fancy-pypi-readme[${PYTHON_USEDEP}]
	test? (
		dev-python/trio[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( anyio )
distutils_enable_tests pytest
