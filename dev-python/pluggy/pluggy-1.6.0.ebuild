# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/pytest-dev/pluggy
PYTHON_COMPAT=( python3_{11..15} python3_{13..15}t pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Plugin and hook calling mechanisms for Python"
HOMEPAGE="
	https://pluggy.readthedocs.io/
	https://github.com/pytest-dev/pluggy/
	https://pypi.org/project/pluggy/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
