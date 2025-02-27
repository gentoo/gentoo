# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 pypy3_11 python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Simple WebSocket server and client for Python"
HOMEPAGE="
	https://github.com/miguelgrinberg/simple-websocket/
	https://pypi.org/project/simple-websocket/
"
# upstream refuses to provide working tests in sdist
# https://github.com/miguelgrinberg/simple-websocket/issues/31
SRC_URI="
	https://github.com/miguelgrinberg/simple-websocket/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/wsproto[${PYTHON_USEDEP}]
"

src_prepare() {
	distutils-r1_src_prepare

	# fix tests to work offline
	# https://github.com/miguelgrinberg/simple-websocket/commit/159e030c7c23060de989cebec6d98d776c75bcbd
	sed -i -e 's:example\.com:localhost:g' tests/test_client.py || die
}

distutils_enable_tests pytest
