# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

DESCRIPTION="SOCKS proxy connector for aiohttp"
HOMEPAGE="https://pypi.org/project/aiohttp-socks/"
SRC_URI="https://github.com/romis2012/aiohttp-socks/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 x86"
# tests require Internet
RESTRICT="test"

# TODO: optional dep on trio
# TODO: is attrs actually used?
RDEPEND="
	>=dev-python/aiohttp-2.3.2[${PYTHON_USEDEP}]
	>=dev-python/attrs-19.2.0[${PYTHON_USEDEP}]
	dev-python/python-socks[${PYTHON_USEDEP}]
"
#DEPEND="
#	test? (
#		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
#	)"

#distutils_enable_tests pytest
