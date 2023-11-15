# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="A CSS Cascading Style Sheets library"
HOMEPAGE="
	https://pypi.org/project/cssutils/
	https://github.com/jaraco/cssutils/
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc x86"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/cssselect[${PYTHON_USEDEP}]
		>=dev-python/jaraco-test-5.1[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# network
		encutils/__init__.py::encutils
		cssutils/tests/test_parse.py::TestCSSParser::test_parseUrl
		examples/website.py::examples.website.logging
	)
	local EPYTEST_IGNORE=(
		# path mismatch with "parse" package
		examples/parse.py
	)

	epytest
}
