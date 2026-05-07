# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Pytest Plugin to disable socket calls during tests"
HOMEPAGE="
	https://github.com/miketheman/pytest-socket/
	https://pypi.org/project/pytest-socket/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( "${PN}" pytest-http{bin,x} )
EPYTEST_PLUGIN_LOAD_VIA_ENV=1
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	tests/test_async.py::test_starlette
	tests/test_restrict_hosts.py::test_help_message

	# require DNS access
	tests/test_async.py::test_httpx_fails
	tests/test_combinations.py::test_parametrize_with_socket_enabled_and_allow_hosts
	tests/test_precedence.py::test_global_disable_and_allow_host
	tests/test_socket.py::test_urllib_succeeds_by_default
	tests/test_socket.py::test_enabled_urllib_succeeds
	tests/test_socket.py::test_disabled_urllib_fails
)
