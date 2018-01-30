# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy{,3} )

inherit distutils-r1

DESCRIPTION="py.test plugin for coverage reporting"
HOMEPAGE="https://github.com/pytest-dev/pytest-cov https://pypi.python.org/pypi/pytest-cov"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc test"

RDEPEND="
	>=dev-python/py-1.4.22[${PYTHON_USEDEP}]
	>=dev-python/pytest-2.7.3[${PYTHON_USEDEP}]
	>=dev-python/cov-core-1.14.0[${PYTHON_USEDEP}]
	>=dev-python/coverage-3.7.1[${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx-py3doc-enhanced-theme[${PYTHON_USEDEP}]
	)
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/virtualenv[${PYTHON_USEDEP}]
		dev-python/fields[${PYTHON_USEDEP}]
		dev-python/process-tests[${PYTHON_USEDEP}]
		|| (
			>=dev-python/pytest-2.8.0[${PYTHON_USEDEP}]
			dev-python/pytest-cache[${PYTHON_USEDEP}]
		)
		=dev-python/pytest-xdist-1.15.0[${PYTHON_USEDEP}]
		dev-python/pytest-capturelog[${PYTHON_USEDEP}]
	)
"

python_compile_all() {
	use doc && sphinx-build -b html docs _build/html
}

python_test() {
	PYTHONPATH="${S}/tests:${BUILD_DIR}/lib" \
		PYTEST_PLUGINS=${PN/-/_} \
		py.test -v -v -x || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && HTML_DOCS=( _build/html/. )
	distutils-r1_python_install_all
}
