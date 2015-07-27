# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/flask-socketio/flask-socketio-0.6.0.ebuild,v 1.1 2015/07/27 19:24:42 zmedico Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="Flask-SocketIO"
DESCRIPTION="Socket.IO integration for Flask applications."
HOMEPAGE="https://flask-socketio.readthedocs.org/ https://github.com/miguelgrinberg/${MY_PN}/ https://pypi.python.org/pypi/${MY_PN}"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/flask-0.9[${PYTHON_USEDEP}]
	>=dev-python/gevent-socketio-0.3.6[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_PN}-${PV}"

# pypi tarball does not contain tests
RESTRICT="test"

python_test() {
	PYTHONPATH="${PWD}" python ./test_socketio.py || die
}
