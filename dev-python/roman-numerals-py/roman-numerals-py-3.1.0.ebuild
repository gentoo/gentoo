# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( pypy3_11 python3_{11..14} python3_{13..14}t )

inherit distutils-r1 pypi

DESCRIPTION="Manipulate roman numerals"
HOMEPAGE="
	https://github.com/AA-Turner/roman-numerals/
	https://pypi.org/project/roman-numerals-py/
"

LICENSE="|| ( 0BSD CC0-1.0 )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

distutils_enable_tests pytest
