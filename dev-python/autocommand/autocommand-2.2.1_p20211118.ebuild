# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

COMMIT="031c9750c74e3313b954b09e3027aaa6595649bb"

DESCRIPTION="Library to create a command-line program from a function"
HOMEPAGE="https://pypi.org/project/autocommand/
	https://github.com/Lucretiel/autocommand"
SRC_URI="
	https://github.com/Lucretiel/autocommand/archive/${COMMIT}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

distutils_enable_tests pytest
