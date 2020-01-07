# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} )
inherit distutils-r1

DESCRIPTION="XPath 1.0/2.0 parsers and selectors for ElementTree and lxml"
HOMEPAGE="https://github.com/sissaschool/elementpath
	https://pypi.org/project/elementpath/"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/xmlschema[${PYTHON_USEDEP}]
	)"

distutils_enable_tests unittest

src_prepare() {
	distutils-r1_src_prepare

	# this test fails depending on system locale + requires some random
	# locales being installed
	sed -e 's:test_compare_strings_function:_&:' \
		-i tests/test_xpath2_parser.py || die
}
