# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/tommilligan/pytest-jobserver
PYTHON_COMPAT=( pypy3_11 python3_{11..14} python3_{13..14}t )

inherit distutils-r1 pypi

DESCRIPTION="Limit parallel tests with POSIX jobserver"
HOMEPAGE="
	https://github.com/tommilligan/pytest-jobserver/
	https://pypi.org/project/pytest-jobserver/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
"

EPYTEST_PLUGIN_LOAD_VIA_ENV=1
EPYTEST_PLUGINS=( "${PN}" pytest-xdist )
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		pytest_jobserver/test/test_plugin.py::test_xdist_makeflags_fails
		# broken by implicit slot fix
		pytest_jobserver/test/test_plugin.py::test_jobserver_token_fixture
		pytest_jobserver/test/test_plugin.py::test_server_xdist
	)

	unset A MAKEFLAGS

	# missing conftest.py
	epytest -p pytester
}
