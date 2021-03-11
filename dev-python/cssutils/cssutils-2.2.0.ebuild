# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="A CSS Cascading Style Sheets library"
HOMEPAGE="https://pypi.org/project/cssutils/ https://cthedot.de/cssutils/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"

BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

python_test() {
	local deselect=(
		# network
		encutils/__init__.py::encutils
		cssutils/tests/test_parse.py::CSSParserTestCase::test_parseUrl
	)

	epytest ${deselect[@]/#/--deselect }
}
