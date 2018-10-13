# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Python docstring style checker"
HOMEPAGE="https://github.com/PyCQA/pydocstyle"
SRC_URI="https://github.com/PyCQA/pydocstyle/archive/${PV}.tar.gz -> ${P}.tar.gz"
# pypi tarball excludes unit tests
#SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
# TODO: investigate unit test failures
RESTRICT="test"

RDEPEND="$(python_gen_cond_dep 'dev-python/configparser[${PYTHON_USEDEP}]' -2)
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/snowballstemmer[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? (
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-3.0.2[${PYTHON_USEDEP}]
		>=dev-python/pytest-pep8-1.0.6[${PYTHON_USEDEP}]
		virtual/python-pathlib[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	distutils-r1_python_prepare_all
	sed -e 's:^\(def \)\(install_package\):\1_\2:' \
		-e 's:^pytestmark =:#\0:' \
		-i src/tests/test_integration.py || die
}

python_test() {
	py.test -v src/tests || die "tests failed with ${EPYTHON}"
}
