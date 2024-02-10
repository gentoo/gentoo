# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Fuzzy string matching in python"
HOMEPAGE="
	https://github.com/seatgeek/fuzzywuzzy/
	https://pypi.org/project/fuzzywuzzy/
"

KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86"
LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	dev-python/Levenshtein[${PYTHON_USEDEP}]
"
# pycodestyle imported unconditionally in the only test file, sigh
BDEPEND="
	test? (
		dev-python/pycodestyle[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
