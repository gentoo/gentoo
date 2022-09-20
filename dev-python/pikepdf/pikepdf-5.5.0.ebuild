# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

MY_P=${P/_p/.post}
DESCRIPTION="Python library to work with pdf files based on qpdf"
HOMEPAGE="
	https://github.com/pikepdf/pikepdf/
	https://pypi.org/project/pikepdf/
"
SRC_URI="
	https://github.com/${PN}/${PN}/archive/v${PV/_p/.post}.tar.gz
		-> ${P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"

DEPEND="
	>=app-text/qpdf-10.6.2:0=
"
RDEPEND="
	${DEPEND}
	dev-python/deprecation[${PYTHON_USEDEP}]
	>=dev-python/lxml-4.0[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/pillow-9[${PYTHON_USEDEP}]
	>=dev-python/pybind11-2.9.1[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/pybind11-2.9.1[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm-7.0.5[${PYTHON_USEDEP}]
	dev-python/setuptools_scm_git_archive[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/tomli[${PYTHON_USEDEP}]
	' 3.8 3.9 3.10)
	test? (
		>=dev-python/attrs-20.2.0[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-5[${PYTHON_USEDEP}]
		>=dev-python/pillow-5.0.0[${PYTHON_USEDEP},jpeg,lcms,tiff]
		>=dev-python/psutil-5[${PYTHON_USEDEP}]
		>=dev-python/pytest-6[${PYTHON_USEDEP}]
		>=dev-python/pytest-timeout-1.4.2[${PYTHON_USEDEP}]
		>=dev-python/python-dateutil-2.8.0[${PYTHON_USEDEP}]
		>=dev-python/python-xmp-toolkit-2.0.1[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	sed -e '/-n auto/d' -i pyproject.toml || die
	distutils-r1_src_prepare
}
