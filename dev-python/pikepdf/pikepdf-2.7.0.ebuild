# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Python library to work with pdf files based on qpdf"
HOMEPAGE="https://pypi.org/project/pikepdf/ https://github.com/pikepdf/pikepdf"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"

DEPEND="app-text/qpdf:0="
RDEPEND="${DEPEND}
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/pybind11[${PYTHON_USEDEP}]"
BDEPEND="
	>=dev-python/pybind11-2.6.0[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm-4.1[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
	dev-python/setuptools_scm_git_archive[${PYTHON_USEDEP}]
	test? (
		>=dev-python/attrs-20.2.0[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-5[${PYTHON_USEDEP}]
		>=dev-python/pillow-5.0.0[${PYTHON_USEDEP},jpeg,lcms,tiff]
		>=dev-python/psutil-5[${PYTHON_USEDEP}]
		>=dev-python/pytest-6[${PYTHON_USEDEP}]
		>=dev-python/pytest-timeout-1.4.2[${PYTHON_USEDEP}]
		>=dev-python/python-dateutil-2.8.0[${PYTHON_USEDEP}]
		>=dev-python/python-xmp-toolkit-2.0.1[${PYTHON_USEDEP}]
	)"

#distutils_enable_sphinx docs \
#	dev-python/ipython \
#	dev-python/matplotlib \
#	dev-python/sphinx_rtd_theme
distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/wheel/d' setup.py || die
	sed -i -e '/-n auto/d' setup.cfg || die
	distutils-r1_src_prepare
}
