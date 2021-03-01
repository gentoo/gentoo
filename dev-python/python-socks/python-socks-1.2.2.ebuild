# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9}  )
inherit distutils-r1

DESCRIPTION="SOCKS4, SOCKS5, HTTP tunneling functionality for Python"
HOMEPAGE="
	https://pypi.org/project/python-socks/
	https://github.com/romis2012/python-socks/"
SRC_URI="
	https://github.com/romis2012/python-socks/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# trio, curio are not packaged
# asyncio is the only backend we have, so dep on its deps unconditionally
RDEPEND="dev-python/async_timeout[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/async_timeout[${PYTHON_USEDEP}]
		dev-python/flask[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/yarl[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest
