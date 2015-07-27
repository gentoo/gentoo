# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/socketio-client/socketio-client-0.5.6.ebuild,v 1.1 2015/07/27 19:55:21 zmedico Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_{3,4}} )

inherit distutils-r1

MY_PN="socketIO-client"
DESCRIPTION="A socket.io client library for Python"
HOMEPAGE="https://github.com/invisibleroads/${MY_PN}/ https://pypi.python.org/pypi/${MY_PN}"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/websocket-client[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${MY_PN}-${PV}"

RESTRICT="test"

python_test() {
	PYTHONPATH="${PWD}" python -m unittest
}
