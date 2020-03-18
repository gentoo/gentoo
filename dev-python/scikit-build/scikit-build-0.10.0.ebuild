# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Improved build system generator for Python C/C++/Fortran/Cython extensions"
HOMEPAGE="https://github.com/scikit-build/scikit-build"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/distro[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]"

DEPEND="test? (
	dev-python/coverage[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/flake8[${PYTHON_USEDEP}]
	dev-python/path-py[${PYTHON_USEDEP}]
	dev-python/pytest-mock[${PYTHON_USEDEP}]
	dev-python/pytest-runner[${PYTHON_USEDEP}]
	dev-python/pytest-virtualenv[${PYTHON_USEDEP}]
	dev-python/PyQt5[testlib,${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/virtualenv[${PYTHON_USEDEP}] )"

PATCHES=( "${FILESDIR}/${P}-docs.patch"
	"${FILESDIR}/${P}-skip-sandbox-violation-tests.patch" )

distutils_enable_sphinx docs dev-python/sphinx_rtd_theme dev-python/sphinx-issues
distutils_enable_tests pytest
