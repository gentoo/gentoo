# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 python3_7 )
inherit distutils-r1

DESCRIPTION="A protocol neutral RPC library that supports JSON-RPC and zmq."
HOMEPAGE="https://github.com/mbr/tinyrpc"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="gevent httpclient jsonext websocket wsgi zmq"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	dev-python/six[${PYTHON_USEDEP}]
	gevent? ( dev-python/gevent[${PYTHON_USEDEP}] )
	httpclient? ( dev-python/requests[${PYTHON_USEDEP}]
		dev-python/websocket-client[${PYTHON_USEDEP}]
		dev-python/gevent-websocket[${PYTHON_USEDEP}]
	)
	websocket? ( dev-python/gevent-websocket[${PYTHON_USEDEP}] )
	wsgi? ( dev-python/werkzeug[${PYTHON_USEDEP}] )
	zmq? ( dev-python/pyzmq[${PYTHON_USEDEP}] )
	jsonext? ( dev-python/jsonext[${PYTHON_USEDEP}] )"
BDEPEND=""
