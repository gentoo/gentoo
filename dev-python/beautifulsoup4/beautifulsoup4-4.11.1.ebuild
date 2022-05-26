# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Pythonic idioms for iterating, searching, and modifying an HTML/XML parse tree"
HOMEPAGE="https://www.crummy.com/software/BeautifulSoup/bs4/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

RDEPEND="
	dev-python/soupsieve[${PYTHON_USEDEP}]
	dev-python/html5lib[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
"
# bs4 prefers cchardet > chardet > charset-normalizer
# however, charset-normalizer causes test failures, so force the other two
# dev-python/chardet[${PYTHON_USEDEP}]
BDEPEND="
	test? (
		|| (
			dev-python/cchardet[${PYTHON_USEDEP}]
			dev-python/chardet[${PYTHON_USEDEP}]
		)
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx doc/source
