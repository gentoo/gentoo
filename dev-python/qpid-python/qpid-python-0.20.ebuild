# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A high-speed platform independent enterprise messaging system for Apache"
HOMEPAGE="http://qpid.apache.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="amd64 x86"
IUSE="doc examples"
LICENSE="MIT"
SLOT="0"

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/epydoc[${PYTHON_USEDEP}] )"

python_compile_all() {
	use doc && "${PYTHON}" setup.py doc_option
}

src_test() {
	# For now rm failing tests requiring making a connection, ? via a running broker
	# Seems 'we' need figure how to start a broker
	sed -e 's:def testReconnect:def _testReconnect:' \
		-e 's:testEstablish:_&:' \
		-e 's:testOpen:_&:' \
		-e 's:testReconnectURLs:_&:' \
		-e 's:testTcpNodelay:_&:' \
		-e 's:testOpenCloseResourceLeaks:_&:' \
		-e 's:testReconnect:_&:' \
		-i qpid/tests/messaging/endpoints.py
	./qpid-python-test
}

python_install_all() {
	use doc && local HTML_DOCS=( ../"${P}"-python2_7/doc/. )
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
