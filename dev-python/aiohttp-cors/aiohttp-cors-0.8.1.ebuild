# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

DESCRIPTION="Implements CORS support for aiohttp asyncio-powered asynchronous HTTP server"
HOMEPAGE="
	https://github.com/aio-libs/aiohttp-cors/
	https://pypi.org/project/aiohttp-cors/
"
SRC_URI="
	https://github.com/aio-libs/aiohttp-cors/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	>=dev-python/aiohttp-3.9[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/selenium[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-{aiohttp,asyncio} )
distutils_enable_tests pytest

python_test() {
	epytest -o addopts= --asyncio-mode=auto
}
