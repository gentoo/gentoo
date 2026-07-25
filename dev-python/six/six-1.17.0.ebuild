# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..15} python3_{13..15}t pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Python 2 and 3 compatibility library"
HOMEPAGE="
	https://github.com/benjaminp/six/
	https://pypi.org/project/six/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

distutils_enable_sphinx documentation --no-autodoc
EPYTEST_PLUGINS=()
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# requires USE=gdb on CPython, no point in forcing the dep
	# also missing on PyPy
	'test_six.py::test_move_items[dbm_ndbm]'
)
