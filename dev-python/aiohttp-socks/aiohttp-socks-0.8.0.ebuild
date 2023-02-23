# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1

DESCRIPTION="SOCKS proxy connector for aiohttp"
HOMEPAGE="
	https://pypi.org/project/aiohttp-socks/
	https://github.com/romis2012/aiohttp-socks/
"
SRC_URI="
	https://github.com/romis2012/aiohttp-socks/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	>=dev-python/aiohttp-2.3.2[${PYTHON_USEDEP}]
	>=dev-python/python-socks-2.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/flask[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/yarl[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
