# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..15} python3_{13..15}t )

inherit distutils-r1 pypi

DESCRIPTION="Objects and routines pertaining to date and time"
HOMEPAGE="
	https://github.com/jaraco/tempora/
	https://pypi.org/project/tempora/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

RDEPEND="
	dev-python/jaraco-context[${PYTHON_USEDEP}]
	>=dev-python/jaraco-functools-4.2[${PYTHON_USEDEP}]
	dev-python/more-itertools[${PYTHON_USEDEP}]
	>=dev-python/jaraco-collections-5.2.1[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( pytest-freezer )
distutils_enable_tests pytest
