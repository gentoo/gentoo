# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="gevent-socketio"
MY_P="${MY_PN}-${PV/_/-}"

DESCRIPTION="SocketIO server based on the Gevent pywsgi server"
HOMEPAGE="https://pypi.python.org/pypi/gevent-socketio/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-python/gevent-websocket[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/gevent[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/versiontools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"
