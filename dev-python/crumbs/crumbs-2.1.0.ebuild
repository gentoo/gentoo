# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 python3_{5,6} )

inherit distutils-r1

DESCRIPTION="Generalized all-in-one parameters module"
HOMEPAGE="https://github.com/alunduil/crumbs"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE="doc test"
RESTRICT="!test? ( test )"

CDEPEND="dev-python/pyinotify[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
	)
	test? (
		${CDEPEND}
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)
"
RDEPEND="${CDEPEND}"

python_compile_all() {
	use doc && esetup.py build_sphinx
}

python_test() {
	nosetests || die "Tests failed on ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )

	distutils-r1_python_install_all
}
