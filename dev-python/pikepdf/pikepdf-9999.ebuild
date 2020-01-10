# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3 distutils-r1
	EGIT_REPO_URI="https://github.com/pikepdf/${PN}.git"
else
	inherit distutils-r1
	SRC_URI="https://github.com/pikepdf/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A Python library for reading and writing PDF, powered by qpdf"
HOMEPAGE="https://pikepdf.readthedocs.io/en/latest/"

LICENSE="MPL-2.0"
SLOT="0"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/setuptools_scm_git_archive[${PYTHON_USEDEP}]
	dev-python/pybind11[${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/pybind11[${PYTHON_USEDEP}]
		dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/pytest-4.4.0[${PYTHON_USEDEP}]
		>=dev-python/attrs-19.1.0[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-4.24.0[${PYTHON_USEDEP}]
		>=dev-python/pillow-5.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-1.28[${PYTHON_USEDEP}]
		dev-python/pytest-helpers-namespace[${PYTHON_USEDEP}]
		dev-python/python-xmp-toolkit[${PYTHON_USEDEP}]
		>=dev-python/pytest-timeout-1.3.3[${PYTHON_USEDEP}]
	)"
RDEPEND="
	dev-python/lxml[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -i "s|test: build|test:|" Makefile || die
	sed -i "/IPython.sphinxext.ipython_directive/d" docs/conf.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	emaket test
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
