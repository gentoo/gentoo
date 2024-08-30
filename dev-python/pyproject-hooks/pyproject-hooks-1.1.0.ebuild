# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1

DESCRIPTION="Wrappers to build Python packages using PEP 517 hooks"
HOMEPAGE="
	https://pypi.org/project/pyproject-hooks/
	https://github.com/pypa/pyproject-hooks/
	https://pyproject-hooks.readthedocs.io/
"
SRC_URI="
	https://github.com/pypa/pyproject-hooks/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

BDEPEND="
	test? (
		dev-python/testpath[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/tomli[${PYTHON_USEDEP}]
		' 3.10)
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# fails due to setuptools 70.1
	# https://bugs.gentoo.org/936052
	# https://github.com/pypa/pyproject-hooks/issues/203
	tests/test_call_hooks.py::test_setup_py
)
