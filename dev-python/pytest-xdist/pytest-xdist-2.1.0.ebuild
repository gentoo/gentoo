# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} pypy3 )

inherit distutils-r1

DESCRIPTION="Distributed testing and loop-on-failing modes"
HOMEPAGE="https://pypi.org/project/pytest-xdist/ https://github.com/pytest-dev/pytest-xdist"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

# please do not depend on pytest to avoid unnecessary USEDEP enforcement
RDEPEND="
	dev-python/execnet[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pytest-forked[${PYTHON_USEDEP}]
"

BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/filelock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	distutils_install_for_testing
	pytest -vv testing || die "Tests failed under ${EPYTHON}"
}
