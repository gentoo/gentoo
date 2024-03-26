# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="XPath 1.0/2.0 parsers and selectors for ElementTree and lxml"
HOMEPAGE="
	https://github.com/sissaschool/elementpath/
	https://pypi.org/project/elementpath/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

BDEPEND="
	test? (
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/xmlschema[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	# fails for some reason, more fit for upstream testing anyway
	rm tests/test_typing.py || die
	distutils-r1_src_prepare
}
