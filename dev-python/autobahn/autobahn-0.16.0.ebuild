# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1 versionator

MY_P="${PN}-$(replace_version_separator 3 -)"

DESCRIPTION="WebSocket and WAMP for Twisted and Asyncio"
HOMEPAGE="https://pypi.python.org/pypi/autobahn http://autobahn.ws/python/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64"
IUSE="crypt test"

RDEPEND="
	$(python_gen_cond_dep '>=dev-python/trollius-2.0[${PYTHON_USEDEP}]' 'python2_7')
	$(python_gen_cond_dep '>=dev-python/futures-3.0.4[${PYTHON_USEDEP}]' 'python2_7')
	$(python_gen_cond_dep '>=dev-python/asyncio-3.4.3[${PYTHON_USEDEP}]' 'python3_3')
	>=dev-python/cbor-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/lz4-0.7.0[${PYTHON_USEDEP}]
	crypt? (
		>=dev-python/pynacl-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/pytrie-0.2[${PYTHON_USEDEP}]
		>=dev-python/pyqrcode-1.1.0[${PYTHON_USEDEP}]
	)
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/snappy-0.5[${PYTHON_USEDEP}]
	|| (
		>=dev-python/twisted-16.0.0[${PYTHON_USEDEP}]
		>=dev-python/twisted-core-12.1[$(python_gen_usedep 'python2*')]
	)
	>=dev-python/txaio-2.5.1[${PYTHON_USEDEP}]
	>=dev-python/u-msgpack-2.1[${PYTHON_USEDEP}]
	>=dev-python/py-ubjson-0.8.4[${PYTHON_USEDEP}]
	>=dev-python/wsaccel-0.6.2[${PYTHON_USEDEP}]
	>=dev-python/zope-interface-3.6[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		>=dev-python/pynacl-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/pytrie-0.2[${PYTHON_USEDEP}]
		>=dev-python/pyqrcode-1.1.0[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}"/${MY_P}

python_test() {
	esetup.py test
}
