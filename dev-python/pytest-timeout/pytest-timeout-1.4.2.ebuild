# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python{2_7,3_{6,7,8,9}} pypy3 )

inherit distutils-r1

DESCRIPTION="py.test plugin to abort hanging tests"
HOMEPAGE="https://pypi.org/project/pytest-timeout/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

# do not rdepend on pytest, it won't be used without it anyway
# pytest-cov used to test compatibility
BDEPEND="
	test? (
		dev-python/pexpect[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/pytest-cov[${PYTHON_USEDEP}]
		' -3)
	)"

distutils_enable_tests pytest

python_test() {
	distutils_install_for_testing

	pytest -vv || die "Tests fail with ${EPYTHON}"
}
