# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Proxy (HTTP, SOCKS) transports for httpx"
HOMEPAGE="
	https://github.com/romis2012/httpx-socks/
	https://pypi.org/project/httpx-socks/
"
SRC_URI="
	https://github.com/romis2012/httpx-socks/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ia64 ~loong ppc ppc64 ~riscv x86"

RDEPEND="
	<dev-python/httpx-0.24.0[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.21.0[${PYTHON_USEDEP}]
	<dev-python/httpcore-0.17.0[${PYTHON_USEDEP}]
	>=dev-python/httpcore-0.14.0[${PYTHON_USEDEP}]
	>=dev-python/python-socks-2.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/hypercorn-0.12.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-asyncio-0.18.3[${PYTHON_USEDEP}]
		>=dev-python/pytest-trio-0.7.0[${PYTHON_USEDEP}]
		>=dev-python/starlette-0.19.1[${PYTHON_USEDEP}]
		>=dev-python/trio-0.18.0[${PYTHON_USEDEP}]
		>=dev-python/yarl-1.6.3[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
