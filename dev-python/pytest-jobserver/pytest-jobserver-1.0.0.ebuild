# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
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

PATCHES=(
	# Combined Gentoo patches:
	# 1. Update MAKEFLAGS parsing:
	#    https://github.com/tommilligan/pytest-jobserver/pull/147
	# 2. Do not require FIFO:
	#    https://github.com/tommilligan/pytest-jobserver/pull/149
	# 3. Acquire job tokens for test collection:
	#    https://github.com/tommilligan/pytest-jobserver/pull/150
	# 4. Do not acquire tokens for gw0 (not submitted yet).
	"${FILESDIR}/${P}-gentoo.patch"
)

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
