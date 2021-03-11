# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Python implementation of the Engine.IO realtime server."
HOMEPAGE="
	https://python-engineio.readthedocs.org/
	https://github.com/miguelgrinberg/python-engineio/
	https://pypi.org/project/python-engineio/"
SRC_URI="
	https://github.com/miguelgrinberg/python-engineio/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/aiohttp[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/websocket-client[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/eventlet[${PYTHON_USEDEP}]
		www-servers/tornado[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest
