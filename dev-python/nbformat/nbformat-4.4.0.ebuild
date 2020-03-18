# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7} )
PYTHON_REQ_USE='sqlite'

inherit distutils-r1

DESCRIPTION="Reference implementation of the Jupyter Notebook format"
HOMEPAGE="https://jupyter.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/jsonschema-2.4.0[${PYTHON_USEDEP}]
	dev-python/ipython_genutils[${PYTHON_USEDEP}]
	>=dev-python/traitlets-4.1[${PYTHON_USEDEP}]
	dev-python/jupyter_core[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/numpydoc[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/testpath[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
	)
	"

python_prepare_all() {
	# Prevent un-needed download during build
	if use doc; then
		sed -e "/^    'sphinx.ext.intersphinx',/d" -i docs/conf.py || die
	fi

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		emake -C docs html
		HTML_DOCS=( docs/_build/html/. )
	fi
}

python_test() {
	distutils_install_for_testing
	cd "${TEST_DIR}"/lib || die
	py.test -v --cov nbformat nbformat || die
}
