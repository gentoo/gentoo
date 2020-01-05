# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="run tests in isolated forked subprocesses"
HOMEPAGE="https://pypi.org/project/pytest-forked/ https://github.com/pytest-dev/pytest-forked"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/pytest-3.1.0[${PYTHON_USEDEP}]"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? ( ${RDEPEND} )"

python_test() {
	distutils_install_for_testing
	pytest -vv -p no:flaky || die "Tests failed under ${EPYTHON}"
}
