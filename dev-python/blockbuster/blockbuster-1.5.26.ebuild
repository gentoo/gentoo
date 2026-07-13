# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} python3_14t )

inherit distutils-r1 pypi

DESCRIPTION="Utility to detect blocking calls in the async event loop"
HOMEPAGE="
	https://github.com/cbornet/blockbuster/
	https://pypi.org/project/blockbuster/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	>=dev-python/forbiddenfruit-0.1.4[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/aiofiles[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-asyncio )
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# Internet
		tests/test_blockbuster.py::test_ssl_socket
	)

	epytest
}
