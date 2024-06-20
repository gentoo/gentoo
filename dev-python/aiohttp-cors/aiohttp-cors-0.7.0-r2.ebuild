# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1

DESCRIPTION="Implements CORS support for aiohttp asyncio-powered asynchronous HTTP server"
HOMEPAGE="
	https://github.com/aio-libs/aiohttp-cors/
	https://pypi.org/project/aiohttp_cors/
"
SRC_URI="
	https://github.com/aio-libs/aiohttp-cors/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/aiohttp-1.1.1[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-aiohttp[${PYTHON_USEDEP}]
		dev-python/selenium[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	local PATCHES=(
		# https://github.com/aio-libs/aiohttp-cors/pull/278
		"${FILESDIR}/${P}-tests.patch"
		"${FILESDIR}/${P}-py3_7.patch"
		# https://github.com/aio-libs/aiohttp-cors/pull/412
		"${FILESDIR}/${P}-py3_11.patch"
	)

	# doesn't do anything, except for breaking pytest-8
	rm conftest.py || die

	distutils-r1_src_prepare
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -o addopts= -p aiohttp -p asyncio --asyncio-mode=auto
}
