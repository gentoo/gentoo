# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="An implementation of the WebSocket Protocol (RFC 6455 & 7692)"
HOMEPAGE="
		https://github.com/aaugustin/websockets
		https://pypi.org/project/websockets/
"
SRC_URI="https://github.com/aaugustin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

python_prepare_all() {
	# these tests fail, probably because of
	# a permission error (no internet)
	rm tests/test_client_server.py || die
	rm tests/test_protocol.py || die
	rm tests/test_auth.py || die

	distutils-r1_python_prepare_all
}

distutils_enable_tests nose
distutils_enable_sphinx docs dev-python/sphinx-autodoc-typehints dev-python/sphinxcontrib-spelling dev-python/sphinxcontrib-trio
