# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{5,6} pypy3 )

inherit distutils-r1

MY_PN="Flask-SocketIO"
DESCRIPTION="Socket.IO integration for Flask applications."
HOMEPAGE="https://flask-socketio.readthedocs.org/ https://github.com/miguelgrinberg/Flask-SocketIO/ https://pypi.org/project/Flask-SocketIO/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-python/flask-0.9[${PYTHON_USEDEP}]
	>=dev-python/python-socketio-1.6.1[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/coverage[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_PN}-${PV}"

# pypi tarball does not contain tests
RESTRICT="test"

python_test() {
	PYTHONPATH="${PWD}" python ./test_socketio.py || die
}
