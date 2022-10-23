# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="pytest plugin that allows multiple failures per test"
HOMEPAGE="
	https://github.com/okken/pytest-check/
	https://pypi.org/project/pytest_check/
"
SRC_URI="mirror://pypi/${P::1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	# Fix expecting result in case pytest throws deprecation warnings
	sed -e '/fnmatch_lines/s/\* /\*/g' \
		-e '/fnmatch_lines/s/ \*/\*/g' \
		-i tests/test_check.py || die

	distutils-r1_src_prepare
}
