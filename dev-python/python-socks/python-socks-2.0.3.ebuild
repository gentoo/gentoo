# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )
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
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

# curio is not packaged
# asyncio is the only backend we have, so dep on its deps unconditionally
# TODO: revisit
RDEPEND="dev-python/async-timeout[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		$(python_gen_cond_dep '
			>=dev-python/anyio-3.4.0[${PYTHON_USEDEP}]
			dev-python/trio[${PYTHON_USEDEP}]
		' 'python*')
		dev-python/async-timeout[${PYTHON_USEDEP}]
		dev-python/flask[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/yarl[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

python_test() {
	# can be removed on next version bump
	epytest --asyncio-mode=strict
}
