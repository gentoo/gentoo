# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Library to create a command-line program from a function"
HOMEPAGE="
	https://github.com/Lucretiel/autocommand/
	https://pypi.org/project/autocommand/
"
SRC_URI="
	https://github.com/Lucretiel/autocommand/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~arm64-macos ~x64-macos"

distutils_enable_tests pytest
