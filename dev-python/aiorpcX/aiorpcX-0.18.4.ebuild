# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Generic async RPC implementation, including JSON-RPC"
HOMEPAGE="https://pypi.org/project/aiorpcX/
	https://github.com/kyuupichan/aiorpcX/"
SRC_URI="https://github.com/kyuupichan/aiorpcX/archive/${PV}.tar.gz
	-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

BDEPEND="
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/uvloop[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

src_prepare() {
	# websockets are optional and not packaged in Gentoo
	rm tests/test_websocket.py || die

	distutils-r1_src_prepare
}
