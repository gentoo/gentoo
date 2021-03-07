# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..8} )

inherit distutils-r1

DESCRIPTION="Generic async RPC implementation, including JSON-RPC"
HOMEPAGE="https://pypi.org/project/aiorpcX/
	https://github.com/kyuupichan/aiorpcX/"
SRC_URI="https://github.com/kyuupichan/aiorpcX/archive/${PV}.tar.gz
	-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

BDEPEND="
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/uvloop[${PYTHON_USEDEP}]
		dev-python/websockets[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

python_test() {
	local deselect=(
		# require Internet
		tests/test_socks.py::TestSOCKSProxy::test_create_connection_resolve_good
	)

	pytest -vv ${deselect[@]/#/--deselect } ||
		die "Tests failed with ${EPYTHON}"
}
