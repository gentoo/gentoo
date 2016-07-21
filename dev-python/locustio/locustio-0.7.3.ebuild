# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=(python2_7)
inherit distutils-r1

DESCRIPTION="A python utility for doing easy, distributed load testing of a web site"
HOMEPAGE="http://locust.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="test? (
		dev-python/unittest2[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pyzmq[${PYTHON_USEDEP}]
	)"
RDEPEND=">=dev-python/gevent-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/flask-0.10.1[${PYTHON_USEDEP}]
	>=dev-python/requests-2.4.1[${PYTHON_USEDEP}]
	>=dev-python/msgpack-0.4.2"[${PYTHON_USEDEP}]

python_test() {
	esetup.py test
}
