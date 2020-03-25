# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Code Metrics in Python"
HOMEPAGE="https://radon.readthedocs.org/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

CDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RCDEPEND="
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/flake8[${PYTHON_USEDEP}]
	dev-python/flake8-polyfill[${PYTHON_USEDEP}]
	dev-python/mando[${PYTHON_USEDEP}]
	dev-python/pytest-mock[${PYTHON_USEDEP}]
"
DEPEND="
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	${CDEPEND}
	test? (
		${RCDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	${CDEPEND}
	${RCDEPEND}
"

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	"${PYTHON}" radon/tests/run.py || die "tests failed to run under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )

	distutils-r1_python_install_all
}
