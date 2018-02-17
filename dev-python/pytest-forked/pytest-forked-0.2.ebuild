# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy{,3} )

inherit distutils-r1

DESCRIPTION="run tests in isolated forked subprocesses"
HOMEPAGE="https://pypi.python.org/pypi/pytest-forked https://github.com/pytest-dev/pytest-forked"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
IUSE="test"

RDEPEND="
	>=dev-python/pytest-2.6.0[${PYTHON_USEDEP}]"

DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]"

python_prepare_all() {
	distutils-r1_python_prepare_all

	# remove bundled bytecode
	rm -r testing/__pycache__ || die
}

python_test() {
	distutils_install_for_testing
	py.test -v || die "Tests failed under ${EPYTHON}"
}
