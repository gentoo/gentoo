# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

MY_PN="socketIO-client"
REPO_PN="socketIO_client"
DESCRIPTION="A socket.io client library for Python"
HOMEPAGE="https://github.com/invisibleroads/socketIO-client/ https://pypi.org/project/socketIO-client/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${REPO_PN}-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/websocket-client[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${REPO_PN}-${PV}"

python_test() {
	# https://github.com/invisibleroads/socketIO-client/issues/90
	# This runs the suite but has nill output to the screen
	# The bug filed will hopefully yield a more conventional testsuite

	# The import of SocketIO need be made with abs path to run the tests
	sed -e 's:from .. import:from socketIO_client import:' \
		-i ${REPO_PN}/tests/__init__.py || die

	"${PYTHON}" ${REPO_PN}/tests/__init__.py || die "Tests failed under ${EPYTHON}"

	# Return to original form for final install
	 sed -e 's:from socketIO_client import:from .. import:' \
		-i ${REPO_PN}/tests/__init__.py || die
}
