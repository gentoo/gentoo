# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Simple proxy server (SOCKS4(a), SOCKS5(h), HTTP tunnel)"
HOMEPAGE="
	https://github.com/romis2012/tiny-proxy/
	https://pypi.org/project/tiny-proxy/
"
SRC_URI="
	https://github.com/romis2012/tiny-proxy/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	<dev-python/anyio-5.0.0[${PYTHON_USEDEP}]
	>=dev-python/anyio-3.6.1[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/aiohttp-3.8.1[${PYTHON_USEDEP}]
		>=dev-python/httpx-0.23.0[${PYTHON_USEDEP}]
		>=dev-python/httpx-socks-0.7.4[${PYTHON_USEDEP}]
		>=dev-python/pytest-asyncio-0.18.3[${PYTHON_USEDEP}]
		>=dev-python/trustme-0.9.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
