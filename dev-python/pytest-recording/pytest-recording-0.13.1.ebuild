# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="A pytest plugin to record network interactions via VCR.py"
HOMEPAGE="
	https://pypi.org/project/pytest-recording/
	https://github.com/kiwicom/pytest-recording/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=dev-python/pytest-3.5.0[${PYTHON_USEDEP}]
	>=dev-python/vcrpy-2.0.1[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-httpbin[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test () {
	local EPYTEST_DESELECT=(
		# Internet
		# https://github.com/kiwicom/pytest-recording/issues/131
		tests/test_blocking_network.py::test_block_network_with_allowed_hosts
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=pytest_recording.plugin
	PYTEST_PLUGINS+=,pytest_httpbin.plugin,pytest_mock
	epytest
}
