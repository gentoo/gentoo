# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} pypy3 )
inherit distutils-r1

DESCRIPTION="Python 2/3 unicode CSV compatibility layer"
HOMEPAGE="
	https://pypi.org/project/csv23/
	https://github.com/xflr6/csv23/"
SRC_URI="https://github.com/xflr6/csv23/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86 ~x64-macos"

BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		>=dev-python/pytest-4.6[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/--cov/d' setup.cfg || die
	distutils-r1_src_prepare
}
