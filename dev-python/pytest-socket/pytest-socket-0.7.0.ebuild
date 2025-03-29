# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Pytest Plugin to disable socket calls during tests"
HOMEPAGE="
	https://github.com/miketheman/pytest-socket/
	https://pypi.org/project/pytest-socket/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-httpbin[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_test() {
	local EPYTEST_DESELECT=(
		tests/test_async.py::test_starlette
		tests/test_restrict_hosts.py::test_help_message
	)

	distutils-r1_src_test
}
