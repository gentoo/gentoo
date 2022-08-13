# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="A CSS Cascading Style Sheets library"
HOMEPAGE="
	https://pypi.org/project/cssutils/
	https://github.com/jaraco/cssutils/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc x86"

BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/cssselect[${PYTHON_USEDEP}]
		>=dev-python/jaraco-test-5.1[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/importlib_resources[${PYTHON_USEDEP}]
		' 3.8)
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# network
	encutils/__init__.py::encutils
	cssutils/tests/test_parse.py::TestCSSParser::test_parseUrl
	examples/website.py::website.logging
)
