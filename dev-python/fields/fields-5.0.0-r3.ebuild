# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Container class boilerplate killer"
HOMEPAGE="
	https://github.com/ionelmc/python-fields/
	https://pypi.org/project/fields/
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

BDEPEND="
	test? (
		dev-python/attrs[${PYTHON_USEDEP}]
		dev-python/characteristic[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	sed -r \
		-e "/--benchmark-disable/d" \
		-e 's|\[pytest\]|\[tool:pytest\]|' \
		-i setup.cfg || die

	distutils-r1_python_prepare_all
}

python_test() {
	epytest --ignore tests/test_perf.py tests
}
