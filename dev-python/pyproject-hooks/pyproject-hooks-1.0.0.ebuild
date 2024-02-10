# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{9..12} pypy3 )

inherit distutils-r1

DESCRIPTION="Wrappers to build Python packages using PEP 517 hooks"
HOMEPAGE="
	https://pypi.org/project/pyproject_hooks/
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

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/tomli[${PYTHON_USEDEP}]
	' 3.{8..10})
"
BDEPEND="
	test? (
		dev-python/testpath[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
