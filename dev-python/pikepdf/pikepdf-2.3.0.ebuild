# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6..9} )
inherit distutils-r1

DESCRIPTION="Python library to work with pdf files based on qpdf"
HOMEPAGE="https://pypi.org/project/pikepdf/ https://github.com/pikepdf/pikepdf"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="app-text/qpdf:0=
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/pybind11[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	>=dev-python/setuptools-50[${PYTHON_USEDEP}]
	>=dev-python/wheel-0.35[${PYTHON_USEDEP}]
	>=dev-python/pybind11-2.6.0[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm-4.1[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
	dev-python/setuptools_scm_git_archive[${PYTHON_USEDEP}]
	test? ( >=dev-python/attrs-20.2.0[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-5[${PYTHON_USEDEP}]
		<dev-python/hypothesis-6.0[${PYTHON_USEDEP}]
		>=dev-python/pillow-5.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-6[${PYTHON_USEDEP}]
		<dev-python/pytest-7[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-2.10.1[${PYTHON_USEDEP}]
		<dev-python/pytest-cov-3[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-1.28[${PYTHON_USEDEP}]
		<dev-python/pytest-xdist-2.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-timeout-1.4.2[${PYTHON_USEDEP}]
		>=dev-python/python-dateutil-2.8.0[${PYTHON_USEDEP}]
		>=dev-python/python-xmp-toolkit-2.0.1[${PYTHON_USEDEP}] )"

PATCHES=( "${FILESDIR}"/${PN}-1.8.3-test.patch )

python_test() {
	pytest
}

# When ipython and matplotlib will get python3_8 support, we'll be able to add
#
#IUSE="doc"
#DEPEND="doc? ( dev-python/ipython
#		dev-python/matplotlib
#		dev-python/sphinx-1.4
#		dev-python/sphinx_rtd_theme )"
#python_compile_all() {
#	use doc && emake -C docs html
#}
#python_install_all() {
#	use doc && local HTML_DOCS=( docs/_build/html/. )
#	distutils-r1_python_install_all
#}
