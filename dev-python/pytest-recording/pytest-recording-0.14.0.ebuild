# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="A pytest plugin to record network interactions via VCR.py"
HOMEPAGE="
	https://pypi.org/project/pytest-recording/
	https://github.com/kiwicom/pytest-recording/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86"

RDEPEND="
	>=dev-python/pytest-3.5.0[${PYTHON_USEDEP}]
	>=dev-python/vcrpy-2.0.1[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/requests[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( "${PN}" pytest-{httpbin,mock} )
EPYTEST_PLUGIN_LOAD_VIA_ENV=1
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Internet
	# https://github.com/kiwicom/pytest-recording/issues/131
	tests/test_blocking_network.py::test_block_network_with_allowed_hosts
)
