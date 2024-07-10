# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Pytest plugin providing a fixture interface for spulec/freezegun"
HOMEPAGE="
	https://github.com/pytest-dev/pytest-freezer/
	https://pypi.org/project/pytest-freezer/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/freezegun-1.0[${PYTHON_USEDEP}]
	>=dev-python/pytest-3.6[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
