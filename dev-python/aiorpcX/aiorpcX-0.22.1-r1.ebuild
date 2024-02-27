# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Generic async RPC implementation, including JSON-RPC"
HOMEPAGE="
	https://github.com/kyuupichan/aiorpcX/
	https://pypi.org/project/aiorpcX/
"
SRC_URI="
	https://github.com/kyuupichan/aiorpcX/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 x86"

BDEPEND="
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/uvloop[${PYTHON_USEDEP}]
		dev-python/websockets[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# require Internet
	tests/test_socks.py::TestSOCKSProxy::test_create_connection_resolve_good
)
