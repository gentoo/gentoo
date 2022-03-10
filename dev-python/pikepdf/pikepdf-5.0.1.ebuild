# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

MY_P=${P/_p/.post}
DESCRIPTION="Python library to work with pdf files based on qpdf"
HOMEPAGE="https://pypi.org/project/pikepdf/ https://github.com/pikepdf/pikepdf"
SRC_URI="
	https://github.com/${PN}/${PN}/archive/v${PV/_p/.post}.tar.gz
		-> ${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=app-text/qpdf-10.6.2:0="
RDEPEND="${DEPEND}
	<dev-python/pillow-10[${PYTHON_USEDEP}]
	>=dev-python/lxml-4.0[${PYTHON_USEDEP}]
	>=dev-python/packaging-20[${PYTHON_USEDEP}]
	>=dev-python/pybind11-2.9.1[${PYTHON_USEDEP}]"
BDEPEND="
	>=dev-python/pybind11-2.9.1[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm-6.4[${PYTHON_USEDEP}]
	dev-python/tomli[${PYTHON_USEDEP}]
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
	sed -i -e '/-n auto/d' pyproject.toml || die
	distutils-r1_src_prepare
}
