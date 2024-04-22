# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Test utilities for code working with files and commands"
HOMEPAGE="
	https://github.com/jupyter/testpath/
	https://testpath.readthedocs.io/en/latest/
	https://pypi.org/project/testpath/
"
SRC_URI="
	https://github.com/jupyter/testpath/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

distutils_enable_tests pytest
distutils_enable_sphinx doc
