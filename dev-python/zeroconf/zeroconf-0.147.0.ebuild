# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Pure Python Multicast DNS Service Discovery Library (Bonjour/Avahi compatible)"
HOMEPAGE="
	https://github.com/python-zeroconf/python-zeroconf/
	https://pypi.org/project/zeroconf/
"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 x86 ~amd64-linux ~x86-linux"
IUSE="+native-extensions"

RDEPEND="
	>=dev-python/ifaddr-0.1.7[${PYTHON_USEDEP}]
"
# the build system uses custom build script that uses distutils to build
# C extensions, sigh
BDEPEND="
	native-extensions? (
		>=dev-python/cython-3.0.8[${PYTHON_USEDEP}]
	)
	>=dev-python/setuptools-65.6.3[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_compile() {
	if use native-extensions; then
		local -x REQUIRE_CYTHON=1
	else
		local -x SKIP_CYTHON=1
	fi

	distutils-r1_python_compile
}

python_test() {
	local -x SKIP_IPV6=1
	local EPYTEST_DESELECT=(
		# network
		tests/test_core.py::Framework::test_close_multiple_times
		tests/test_core.py::Framework::test_launch_and_close
		tests/test_core.py::Framework::test_launch_and_close_context_manager

		# fragile to timeouts (?)
		tests/services/test_browser.py::test_service_browser_expire_callbacks
		tests/utils/test_asyncio.py::test_run_coro_with_timeout

		# randomly broken by a leftover thread?
		tests/test_circular_imports.py::test_circular_imports
	)
	local EPYTEST_IGNORE=(
		tests/benchmarks
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -o addopts= -p asyncio
}
