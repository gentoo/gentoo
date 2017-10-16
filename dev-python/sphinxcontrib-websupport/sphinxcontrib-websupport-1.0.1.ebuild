# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="Sphinx websupport extension"
HOMEPAGE="http://www.sphinx-doc.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 x86 ~amd64-linux ~x86-linux ~x64-solaris"
IUSE="test"

CDEPEND="
	>=dev-python/sqlalchemy-0.9[${PYTHON_USEDEP}]
	>=dev-python/whoosh-2.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.5[${PYTHON_USEDEP}]
	>=dev-python/sphinx-1.5.3[${PYTHON_USEDEP}]
	dev-python/namespace-sphinxcontrib[${PYTHON_USEDEP}]
"
DEPEND="${CDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/tox[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)
"
RDEPEND="${CDEPEND}"

python_install_all() {
	distutils-r1_python_install_all
	find "${ED}" -name '*.pth' -delete || die
}

python_test(){
	${EPYTHON} -m pytest tests/
}
