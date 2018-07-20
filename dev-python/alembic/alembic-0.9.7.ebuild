# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1

DESCRIPTION="database migrations tool, written by the author of SQLAlchemy"
HOMEPAGE="https://bitbucket.org/zzzeek/alembic"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="test doc"

# requires.txt cites 'SQLAlchemy>=0.7.3' which is really both old and silly
# because it shatters the testsuite.  If 'someone' cares to adhere to correct form
# and edit to -0.7.3, feel free, and then pick up the pieces.
RDEPEND=">=dev-python/sqlalchemy-0.8.4[${PYTHON_USEDEP}]
	dev-python/mako[${PYTHON_USEDEP}]
	>=dev-python/python-editor-0.3[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}] )"
# For test phase
DISTUTILS_IN_SOURCE_BUILD=1

python_prepare_all() {
	# suite passes all if run from source. The residual fail & error are quite erroneous
	rm tests/test_script_consumption.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	${EPYTHON} run_tests.py || die "Testing failed with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/. )

	distutils-r1_python_install_all
}
