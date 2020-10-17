# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Easy to use fixtures to write regression tests"
HOMEPAGE="https://github.com/ESSS/pytest-regressions"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="test? (
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/tox[${PYTHON_USEDEP}]
)"

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/pytest-datadir[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
distutils_enable_sphinx doc dev-python/sphinx_rtd_theme

python_test() {
	distutils_install_for_testing
	pytest -vv || die "Tests failed with ${EPYTHON}"
}
