# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

MY_PN="socketIO-client-nexus"
DESCRIPTION="A socket.io 2.x client library for Python"
HOMEPAGE="https://github.com/nexus-devs/socketIO-client-2.0.3/ https://pypi.org/project/socketIO-client-nexus/"
S="${WORKDIR}/${MY_PN}-${PV}"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# require network
RESTRICT="test"

RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/websocket-client[${PYTHON_USEDEP}]"
