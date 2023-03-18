# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1

DESCRIPTION="SOCKS4, SOCKS5, HTTP tunneling functionality for Python"
HOMEPAGE="
	https://github.com/romis2012/python-socks/
	https://pypi.org/project/python-socks/
"
SRC_URI="
	https://github.com/romis2012/python-socks/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

# curio is not packaged
# asyncio is the only backend we have, so dep on its deps unconditionally
# TODO: revisit
RDEPEND="
	dev-python/async-timeout[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/anyio-3.4.0[${PYTHON_USEDEP}]
		>=dev-python/async-timeout-3.0.1[${PYTHON_USEDEP}]
		>=dev-python/flask-1.1.2[${PYTHON_USEDEP}]
		>=dev-python/pytest-asyncio-0.18.3[${PYTHON_USEDEP}]
		>=dev-python/pytest-trio-0.7.0[${PYTHON_USEDEP}]
		>=dev-python/tiny-proxy-0.1.1[${PYTHON_USEDEP}]
		>=dev-python/trio-0.16.0[${PYTHON_USEDEP}]
		>=dev-python/trustme-0.9.0[${PYTHON_USEDEP}]
		>=dev-python/yarl-1.4.2[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
