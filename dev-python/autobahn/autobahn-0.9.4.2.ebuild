# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} )

inherit distutils-r1 versionator

MY_P="${PN}-$(replace_version_separator 3 -)"

DESCRIPTION="WebSocket and WAMP for Twisted and Asyncio"
HOMEPAGE="https://pypi.python.org/pypi/autobahn http://autobahn.ws/python/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.zip"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="amd64 arm x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-python/snappy[${PYTHON_USEDEP}]
	dev-python/lz4[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}]
	dev-python/twisted-core[$(python_gen_usedep 'python2*')]
	dev-python/ujson[${PYTHON_USEDEP}]
	dev-python/wsaccel[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MY_P}
