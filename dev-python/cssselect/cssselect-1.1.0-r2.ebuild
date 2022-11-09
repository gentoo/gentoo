# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="parses CSS3 Selectors and translates them to XPath 1.0"
HOMEPAGE="
	https://cssselect.readthedocs.io/en/latest/
	https://pypi.org/project/cssselect/
	https://github.com/scrapy/cssselect/
"
SRC_URI="
	https://github.com/scrapy/cssselect/archive/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

BDEPEND="
	test? (
		dev-python/lxml[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs
distutils_enable_tests unittest
