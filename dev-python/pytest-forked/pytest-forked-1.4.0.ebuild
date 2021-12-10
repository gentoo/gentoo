# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

DESCRIPTION="run tests in isolated forked subprocesses"
HOMEPAGE="https://pypi.org/project/pytest-forked/ https://github.com/pytest-dev/pytest-forked"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

# Please do not RDEPEND on pytest; this package won't do anything
# without pytest installed, and there is no reason to force older
# implementations on pytest.
RDEPEND="dev-python/py[${PYTHON_USEDEP}]"
BDEPEND="dev-python/setuptools_scm[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

python_test() {
	distutils_install_for_testing
	epytest -p no:flaky
}
