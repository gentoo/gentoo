# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1

MY_PN=""
DESCRIPTION="Python implementation of the Socket.IO realtime server."
HOMEPAGE="https://${PN}.readthedocs.org/ https://github.com/miguelgrinberg/${PN}/ https://pypi.python.org/pypi/${PN}"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/python-engineio-0.7.0[${PYTHON_USEDEP}]
	!dev-python/gevent-socketio"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pbr[${PYTHON_USEDEP}]
	)"

# pypi tarball does not contain tests
RESTRICT="test"

src_prepare() {
	sed -e 's:pbr<1.7.0:pbr:' -i setup.py || die
	distutils-r1_src_prepare
}

python_test() {
	esetup.py test || die
}
