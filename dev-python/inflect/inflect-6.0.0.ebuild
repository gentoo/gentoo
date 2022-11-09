# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Correctly inflect words and numbers"
HOMEPAGE="
	https://pypi.org/project/inflect/
	https://github.com/jaraco/inflect/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

RDEPEND="
	dev-python/pydantic[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools_scm-3.4.1[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
