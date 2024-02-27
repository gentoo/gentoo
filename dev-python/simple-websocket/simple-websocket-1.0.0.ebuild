# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

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

distutils_enable_tests pytest
