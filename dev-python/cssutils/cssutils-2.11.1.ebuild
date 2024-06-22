# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="A CSS Cascading Style Sheets library"
HOMEPAGE="
	https://pypi.org/project/cssutils/
	https://github.com/jaraco/cssutils/
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc x86"

RDEPEND="
	dev-python/more-itertools[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/cssselect[${PYTHON_USEDEP}]
		>=dev-python/jaraco-test-5.1[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/lxml[${PYTHON_USEDEP}]
		' 3.10)
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# network
		encutils/__init__.py::encutils
		examples/website.py::examples.website.logging
	)
	local EPYTEST_IGNORE=(
		# path mismatch with "parse" package
		examples/parse.py
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -m "not network"
}
