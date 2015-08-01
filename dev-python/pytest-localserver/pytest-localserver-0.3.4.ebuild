# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pytest-localserver/pytest-localserver-0.3.4.ebuild,v 1.2 2015/08/01 10:46:38 patrick Exp $

EAPI=5
PYTHON_COMPAT=(python{2_7,3_3,3_4})

inherit distutils-r1

DESCRIPTION="Py.test plugin to test server connections locally"
HOMEPAGE="https://pypi.python.org/pypi/pytest-localserver"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND=">=dev-python/werkzeug-0.10[${PYTHON_USEDEP}]"
DEPEND="app-arch/unzip
	test? ( ${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}] )"

python_test() {
	py.test || die
}
