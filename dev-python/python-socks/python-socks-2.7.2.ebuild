# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

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
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

# curio is not packaged
# asyncio is the only backend we have, so dep on its deps unconditionally
# TODO: revisit
BDEPEND="
	test? (
		>=dev-python/async-timeout-3.0.1[${PYTHON_USEDEP}]
		>=dev-python/flask-1.1.2[${PYTHON_USEDEP}]
		>=dev-python/tiny-proxy-0.1.1[${PYTHON_USEDEP}]
		>=dev-python/trio-0.24[${PYTHON_USEDEP}]
		>=dev-python/trustme-0.9.0[${PYTHON_USEDEP}]
		>=dev-python/yarl-1.4.2[${PYTHON_USEDEP}]
	)
"

# Test markers exist to exclude trio etc if needed
EPYTEST_PLUGINS=( anyio pytest-{asyncio,trio} )
distutils_enable_tests pytest
