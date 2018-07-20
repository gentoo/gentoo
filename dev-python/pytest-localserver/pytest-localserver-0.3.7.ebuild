# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=(python{2_7,3_4,3_5,3_6} pypy)

inherit distutils-r1

DESCRIPTION="Py.test plugin to test server connections locally"
HOMEPAGE="https://pypi.org/project/pytest-localserver/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="test"

RDEPEND=">=dev-python/werkzeug-0.10[${PYTHON_USEDEP}]"
DEPEND="test? ( ${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}] )"

python_test() {
	py.test -v || die
}
