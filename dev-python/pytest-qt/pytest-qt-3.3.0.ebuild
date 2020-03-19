# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 virtualx

DESCRIPTION="pytest plugin for PyQt4 or PyQt5 applications"
HOMEPAGE="https://pypi.org/project/pytest-qt https://github.com/pytest-dev/pytest-qt"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/QtPy[gui,testlib,${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}/${P}-skip-show-window-test.patch" )

distutils_enable_tests pytest
distutils_enable_sphinx docs dev-python/sphinx_rtd_theme

python_test() {
	pytest_qt_test() {
		# pytest-qt test fail to test in ${BUILDIR}/lib
		# if and only if pytest-qt is not already installed
		# test do work if executed directly in the extracted tarball
		local PYTHONPATH="${WORKDIR}/${P}"
		pytest -vv
	}

	virtx pytest_qt_test
}
