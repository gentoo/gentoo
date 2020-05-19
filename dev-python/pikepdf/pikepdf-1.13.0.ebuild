# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1

DESCRIPTION="Python library to work with pdf files based on qpdf"
HOMEPAGE="https://pypi.org/project/pikepdf/ https://github.com/pikepdf/pikepdf"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="app-text/qpdf
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/pybind11[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools_scm_git_archive[${PYTHON_USEDEP}]
	test? ( >=dev-python/attrs-19.1.0
		>=dev-python/hypothesis-4.24
		<dev-python/hypothesis-5.3.5
		>=dev-python/pillow-5.0.0
		>=dev-python/pytest-4.4.0
		<dev-python/pytest-5.3.5
		>=dev-python/pytest-xdist-1.28
		<dev-python/pytest-xdist-2.0
		>=dev-python/pytest-helpers-namespace-2019.1.8
		>=dev-python/pytest-timeout-1.3.3
		>=dev-python/python-xmp-toolkit-2.0.1 )"

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
