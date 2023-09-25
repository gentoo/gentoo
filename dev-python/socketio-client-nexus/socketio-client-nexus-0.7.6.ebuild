# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )
PYPI_NO_NORMALIZE=1
PYPI_PN="socketIO-client-nexus"

inherit distutils-r1 pypi

DESCRIPTION="A socket.io 2.x client library for Python"
HOMEPAGE="https://github.com/nexus-devs/socketIO-client-2.0.3/ https://pypi.org/project/socketIO-client-nexus/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# require network
RESTRICT="test"

RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/websocket-client[${PYTHON_USEDEP}]"
