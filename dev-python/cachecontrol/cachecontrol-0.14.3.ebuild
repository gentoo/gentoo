# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="httplib2 caching for requests"
HOMEPAGE="
	https://pypi.org/project/CacheControl/
	https://github.com/psf/cachecontrol/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	<dev-python/msgpack-2[${PYTHON_USEDEP}]
	>=dev-python/msgpack-0.5.2[${PYTHON_USEDEP}]
	>=dev-python/requests-2.16.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/cherrypy[${PYTHON_USEDEP}]
		>=dev-python/filelock-3.8.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=()

	if [[ ${EPYTHON} == pypy3* ]]; then
		EPYTEST_DESELECT+=(
			tests/test_adapter.py::TestSessionActions::test_do_not_leak_response
		)
	fi

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
