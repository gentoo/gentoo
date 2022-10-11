# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Python module to propose a modern general-purpose parsing library for Python"
HOMEPAGE="
	https://github.com/lark-parser/lark/
	https://pypi.org/project/lark/
"
SRC_URI="mirror://pypi/${PN:0:1}/lark/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

BDEPEND="
	test? (
		dev-python/atomicwrites[${PYTHON_USEDEP}]
		dev-python/regex[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# require dev-python/js2py which is a really bad quality package
	tests/test_nearley/test_nearley.py
)
