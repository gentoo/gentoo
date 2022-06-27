# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

MY_PN="socketIO-client"
DESCRIPTION="A socket.io client library for Python"
HOMEPAGE="https://github.com/invisibleroads/socketIO-client/ https://pypi.org/project/socketIO-client/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]
		>=dev-python/requests-2.7.0[${PYTHON_USEDEP}]
		dev-python/websocket-client[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${MY_PN}-${PV}"

python_test() {
	# https://github.com/invisibleroads/socketIO-client/issues/90
	# This runs the suite but has nill output to the screen
	# The bug filed will hopefully yield a more conventional testsuite

	# The import of SocketIO need be made with abs path to run the tests
	sed -e 's:from .. import:from socketIO_client import:' \
		-i socketIO_client/tests/__init__.py || die
	sed -e 's:from ..exceptions import:from socketIO_client.exceptions import:' \
		-i socketIO_client/tests/__init__.py || die

	"${PYTHON}" socketIO_client/tests/__init__.py || \
		die "Tests failed under ${EPYTHON}"

	# Return to original form for final install
	sed -e 's:from socketIO_client import:from .. import:' \
		-i socketIO_client/tests/__init__.py || die
	sed -e 's:from socketIO_client.exceptions import:from ..exceptions import:' \
		-i socketIO_client/tests/__init__.py || die
}
