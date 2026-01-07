# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} pypy3 pypy3_11 )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1 pypi

DESCRIPTION="Distributed object middleware for Python (RPC)"
HOMEPAGE="
	https://pyro5.readthedocs.io/
	https://github.com/irmen/Pyro5/
	https://pypi.org/project/Pyro5/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/build[${PYTHON_USEDEP}]
	>=dev-python/serpent-1.40[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
distutils_enable_sphinx docs/source \
	dev-python/sphinx-rtd-theme

python_test() {
	local EPYTEST_DESELECT=(
		# https://github.com/irmen/Pyro5/issues/83 (pypy3 specific)
		tests/test_server.py::TestServerOnce::testRegisterWeak
	)

	epytest -m 'not network'
}
