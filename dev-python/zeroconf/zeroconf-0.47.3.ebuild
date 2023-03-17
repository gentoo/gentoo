# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

MY_P=python-zeroconf-${PV}
DESCRIPTION="Pure Python Multicast DNS Service Discovery Library (Bonjour/Avahi compatible)"
HOMEPAGE="
	https://github.com/python-zeroconf/python-zeroconf/
	https://pypi.org/project/zeroconf/
"
SRC_URI="
	https://github.com/python-zeroconf/python-zeroconf/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/ifaddr-0.1.7[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/async-timeout-3.0.0[${PYTHON_USEDEP}]
	' 3.{8..10})
"
# the build system uses custom build script that uses distutils to build
# C extensions, sigh
BDEPEND="
	>=dev-python/cython-0.29.32[${PYTHON_USEDEP}]
	>=dev-python/setuptools-65.6.3[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# network
		tests/test_core.py::Framework::test_close_multiple_times
		tests/test_core.py::Framework::test_launch_and_close
		tests/test_core.py::Framework::test_launch_and_close_context_manager
		tests/test_core.py::Framework::test_launch_and_close_v4_v6
		tests/test_core.py::Framework::test_launch_and_close_v6_only
		tests/services/test_types.py::ServiceTypesQuery::test_integration_with_listener_ipv6

		# fragile to timeouts (?)
		tests/services/test_browser.py::test_service_browser_expire_callbacks
		tests/utils/test_asyncio.py::test_run_coro_with_timeout
	)

	epytest -o addopts=
}
