# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="A CSS Cascading Style Sheets library"
HOMEPAGE="https://pypi.org/project/cssutils/ https://cthedot.de/cssutils/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc x86"

BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
	test? (
		dev-python/cssselect[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/importlib_resources[${PYTHON_USEDEP}]
		' python3_8 pypy3)
	)"

PATCHES=(
	"${FILESDIR}/${P}-fix-py3.8.patch"
	"${FILESDIR}/${P}-fix-py3.10.patch"
)

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# network
	encutils/__init__.py::encutils
	cssutils/tests/test_parse.py::CSSParserTestCase::test_parseUrl
	examples/website.py::website.logging
)
